data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

#====================#
# Assume Role Policy #
#====================#

data "aws_iam_policy_document" "replication_assume_role" {
  count = var.create_replication_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

#=================#
# Resource Policy #
#=================#

data "aws_iam_policy_document" "replication_role" {
  count = var.create_replication_role ? 1 : 0

  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    actions = [
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }

  statement {
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags"
    ]
    resources = [
      for destination in var.replication_configurations : "${destination.destination_bucket_arn}/*"
    ]
  }

  dynamic "statement" {
    for_each = length([
      for destination in var.replication_configurations : destination.destination_bucket_kms_arn if destination.destination_bucket_kms_arn != null
    ]) == 0 && var.kms_key == null ? [] : [1]

    content {
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:GenerateRandom",
        "kms:GetKeyPolicy",
        "kms:ListAliases",
        "kms:ReEncrypt*"
      ]
      resources = concat(
        [
          for destination in var.replication_configurations : destination.destination_bucket_kms_arn
        ],
        var.kms_key == null ? [] : [var.kms_key]
      )
    }
  }
}

data "aws_iam_policy_document" "full_access" {
  statement {
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "resource_policy" {
  count = local.create_resource_policy ? 1 : 0

  statement {
    sid = "AllowAntivirusRole"

    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = var.antivirus_role_arns
    }

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }

  statement {
    sid    = "DefaultStatement"
    effect = "Allow"

    actions = ["s3:*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [data.aws_caller_identity.this.account_id]
    }

    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.this.account_id,
        var.account_admin_role_arn
      ]
    }

    resources = ["arn:aws:s3:::${local.bucket_name}"]
  }
}
