#==========#
# IAM Role #
#==========#

resource "aws_iam_role" "replication_role" {
  count = var.create_replication_role ? 1 : 0

  name               = "${local.naming.iam}S3ReplicationRole"
  assume_role_policy = data.aws_iam_policy_document.replication_assume_role[0].json

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} S3 Replication Role" })
  )
}

#==============#
# IAM Policies #
#==============#

resource "aws_iam_policy" "replication_role" {
  count = var.create_replication_role ? 1 : 0

  name   = "${local.naming.iam}S3ReplicationAccess"
  policy = data.aws_iam_policy_document.replication_role[0].json
  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.naming.display} S3 Replication Access" })
  )
}
resource "aws_iam_policy" "full_access" {
  count = local.create_resource_policy ? 0 : 1

  name   = "${local.naming.iam}FullAccess"
  policy = data.aws_iam_policy_document.full_access.json

  tags = merge(
    local.tags,
    tomap({ Name = "${local.naming.display} Bucket Full Access" })
  )
}

#=========================#
# Role Policy Attachments #
#=========================#

resource "aws_iam_role_policy_attachment" "replication_role" {
  count = var.create_replication_role ? 1 : 0

  role       = aws_iam_role.replication_role[0].name
  policy_arn = aws_iam_policy.replication_role[0].arn
}
