resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} Bucket" })
  )

  lifecycle {
    ignore_changes = [
      bucket,
      replication_configuration
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = local.create_resource_policy || var.policy != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = local.create_resource_policy ? data.aws_iam_policy_document.resource_policy[0].json : var.policy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.server_side_encryption_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key
      sse_algorithm     = var.kms_key == null ? "AES256" : "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

#===============================#
# S3 Notification Configuration #
#===============================#

resource "aws_s3_bucket_notification" "bucket_notification" {
  count = length(var.bucket_notification_sns_topic_arns)

  bucket = aws_s3_bucket.this.id
  topic {
    topic_arn = var.bucket_notification_sns_topic_arns[count.index]
    events    = ["s3:ObjectCreated:*"]
  }
}

#================#
# S3 Bucket ACLs #
#================#

resource "aws_s3_bucket_acl" "canned_acl" {
  count = var.disable_canned_acl ? 0 : 1

  bucket = aws_s3_bucket.this.id
  acl    = var.canned_acl
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

#=============================#
# S3 Lifecycle Configurations #
#=============================#

resource "aws_s3_bucket_lifecycle_configuration" "all_versions_transitions" {
  count = var.create_lifecycle_rule && !var.create_versioning_lifecycle_rule ? 1 : 0

  bucket = aws_s3_bucket.this.bucket
  rule {
    id = "AllVersions-StorageClassTransitions"
    filter {}

    transition {
      days          = var.lifecycle_rule_standard_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.lifecycle_rule_glacier_days
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "noncurrent_version_transitions_and_expiration" {
  count = var.create_versioning_lifecycle_rule ? 1 : 0

  bucket = aws_s3_bucket.this.bucket
  rule {
    id = "NonCurrentVersion-StorageClassTransitionsAndExpiration"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_rule_expiration_days
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_rule_standard_ia_days
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.lifecycle_rule_glacier_days
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

#==============================#
# S3 Replication Configuration #
#==============================#

resource "aws_s3_bucket_replication_configuration" "this" {
  for_each = var.replication_configurations

  role   = coalesce(each.value.replication_role_arn, aws_iam_role.replication_role[0].arn)
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "${local.naming.iam}_${each.value.destination_account_name}_${each.key}_Replication"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      account       = coalesce(each.value.destination_account_id, data.aws_caller_identity.this.account_id)
      bucket        = each.value.destination_bucket_arn
      storage_class = "STANDARD"

      access_control_translation {
        owner = "Destination"
      }

      dynamic "encryption_configuration" {
        for_each = each.value.destination_bucket_kms_arn == null ? [] : [1]

        content {
          replica_kms_key_id = each.value.destination_bucket_kms_arn
        }
      }
    }
    source_selection_criteria {
      replica_modifications {
        status = "Enabled"
      }
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
  }
}
