locals {
  bucket_name            = lower("${var.tagging.tag_key_prefix}-${local.naming.resource}-${data.aws_region.this.name}")
  create_resource_policy = length(var.antivirus_role_arns) > 0
}
