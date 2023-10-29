# S3 Bucket

This module provisions a S3 bucket

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.canned_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.all_versions_transitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.noncurrent_version_transitions_and_expiration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_admin_role_arn"></a> [account\_admin\_role\_arn](#input\_account\_admin\_role\_arn) | ARN of bucket's AccountAdmin IAM Role | `string` | `null` | no |
| <a name="input_acl"></a> [acl](#input\_acl) | (Deprecated) See the `canned_acl` variable for details. | `string` | `"private"` | no |
| <a name="input_antivirus_role_arns"></a> [antivirus\_role\_arns](#input\_antivirus\_role\_arns) | ARN of S3 Antivirus Lambda IAM Role | `list(string)` | `[]` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. Enabling this setting does not affect existing policies or ACLs | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy | `bool` | `true` | no |
| <a name="input_bucket_notification_sns_topic_arns"></a> [bucket\_notification\_sns\_topic\_arns](#input\_bucket\_notification\_sns\_topic\_arns) | A collection of SNS topic ARNs to publish bucket notifications to | `list(string)` | `[]` | no |
| <a name="input_canned_acl"></a> [canned\_acl](#input\_canned\_acl) | (Optional, Conflicts with `access_control_policy`) The canned ACL to apply to the bucket | `string` | `"private"` | no |
| <a name="input_create_lifecycle_rule"></a> [create\_lifecycle\_rule](#input\_create\_lifecycle\_rule) | (Optional, Conflicts with `create_versioning_lifecycle_rule`) Specifies whether or not to create a lifecycle rule for transitioning storage classes for all versions | `bool` | `false` | no |
| <a name="input_create_replication_role"></a> [create\_replication\_role](#input\_create\_replication\_role) | Specifies whether or not to enable bucket versioning.  If this is false | `bool` | `false` | no |
| <a name="input_create_versioning_lifecycle_rule"></a> [create\_versioning\_lifecycle\_rule](#input\_create\_versioning\_lifecycle\_rule) | (Optional, Conflicts with `create_lifecycle_rule`) Specifies whether or not to create a lifecycle rule for transitioning storage classes and expiring non-current versions | `bool` | `false` | no |
| <a name="input_disable_canned_acl"></a> [disable\_canned\_acl](#input\_disable\_canned\_acl) | Disable canned ACL module resource to use a `aws_s3_bucket_acl` resource outside of the module with a customer `access_control_policy` | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | A naming object for the environment to provide both the environment's name and abbrevation for tagging and reporting purposes | <pre>object({<br>    name         = string<br>    abbreviation = string<br>  })</pre> | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set | `bool` | `true` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The ID of a KMS Key to be used for encrypting the bucket | `string` | `null` | no |
| <a name="input_lifecycle_rule_expiration_days"></a> [lifecycle\_rule\_expiration\_days](#input\_lifecycle\_rule\_expiration\_days) | Specifies the number of days after which an object's non-current version will be expired | `number` | `180` | no |
| <a name="input_lifecycle_rule_glacier_days"></a> [lifecycle\_rule\_glacier\_days](#input\_lifecycle\_rule\_glacier\_days) | Specifies the number of days after which an object's (or an object version's) storage class will be transitioned to STANDARD\_IA | `number` | `60` | no |
| <a name="input_lifecycle_rule_standard_ia_days"></a> [lifecycle\_rule\_standard\_ia\_days](#input\_lifecycle\_rule\_standard\_ia\_days) | Specifies the number of days after which an object's (or an object version's) storage class will be transitioned to STANDARD\_IA | `number` | `30` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | A naming object to provide the display name of the service from the service catalog, and optionally also a resource name | <pre>object({<br>    display  = string<br>    resource = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | A resource policy to be applied to the bucket | `string` | `null` | no |
| <a name="input_replication_configurations"></a> [replication\_configurations](#input\_replication\_configurations) | A map of replication configuration rule objects | <pre>map(object({<br>    replication_role_arn       = optional(string)<br>    destination_account_id     = optional(string)<br>    destination_account_name   = string<br>    destination_region         = optional(string)<br>    destination_bucket_arn     = string<br>    destination_bucket_kms_arn = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked | `bool` | `true` | no |
| <a name="input_server_side_encryption_enabled"></a> [server\_side\_encryption\_enabled](#input\_server\_side\_encryption\_enabled) | Specifies whether or not to enable server side encryption | `bool` | `false` | no |
| <a name="input_tagging"></a> [tagging](#input\_tagging) | A collection of tags as key-value pairs to be applied to all applicable provisioned resources | <pre>object({<br>    additional_tags = optional(map(any), {})<br>    network         = optional(string, null)<br>    organization    = string<br>    owner           = string<br>    service_pattern = string<br>    tag_key_prefix  = string<br>  })</pre> | n/a | yes |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Specifies whether or not to enable bucket versioning | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the S3 bucket |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The name of the S3 bucket |
| <a name="output_full_access_policy_arn"></a> [full\_access\_policy\_arn](#output\_full\_access\_policy\_arn) | The ARN of a full access IAM Policy.  This policy is not created if a resource policy is applied |
| <a name="output_full_access_policy_name"></a> [full\_access\_policy\_name](#output\_full\_access\_policy\_name) | The name of a full access IAM Policy.  This policy is not created if a resource policy is applied |
| <a name="output_name"></a> [name](#output\_name) | The name of the S3 bucket |
| <a name="output_region"></a> [region](#output\_region) | The AWS region in which the bucket is located |
<!-- END_TF_DOCS -->
