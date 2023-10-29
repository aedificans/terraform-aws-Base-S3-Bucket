output "arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}
output "bucket" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}
output "name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}
output "region" {
  description = "The AWS region in which the bucket is located"
  value       = aws_s3_bucket.this.region
}
output "full_access_policy_arn" {
  description = "The ARN of a full access IAM Policy.  This policy is not created if a resource policy is applied"
  value       = local.create_resource_policy ? null : aws_iam_policy.full_access[0].arn
}
output "full_access_policy_name" {
  description = "The name of a full access IAM Policy.  This policy is not created if a resource policy is applied"
  value       = local.create_resource_policy ? null : aws_iam_policy.full_access[0].name
}
