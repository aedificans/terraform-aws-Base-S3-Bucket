#==================#
# Naming & Tagging #
#==================#

variable "environment" {
  description = "A naming object for the environment to provide both the environment's name and abbrevation for tagging and reporting purposes"
  type = object({
    name         = string
    abbreviation = string
  })
  default = null

  validation {
    condition     = can(regex("^[a-zA-Z 0-9\\-]*$", var.environment.name)) || var.environment == null
    error_message = "The environment name must only contain alphanumeric characters, spaces, and hyphens"
  }
  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.environment.abbreviation)) || var.environment == null
    error_message = "The environment abbreviation must be kebab case"
  }
}
variable "naming" {
  description = "A naming object to provide the display name of the service from the service catalog, and optionally also a resource name"
  type = object({
    display  = string
    resource = optional(string, null)
  })

  validation {
    condition     = can(regex("^[a-zA-Z 0-9\\-]*$", var.naming.display))
    error_message = "The service display name must only contain alphanumeric characters, spaces, and hyphens"
  }
  validation {
    condition     = can(regex("^[a-z0-9\\-]*$", var.naming.resource)) || var.naming.resource == null
    error_message = "If provided, the service resource name must be kebab case"
  }
}
variable "tagging" {
  description = "A collection of tags as key-value pairs to be applied to all applicable provisioned resources"
  type = object({
    additional_tags = optional(map(any), {})
    network         = optional(string, null)
    organization    = string
    owner           = string
    service_pattern = string
    tag_key_prefix  = string
  })
}

#======================#
# Bucket Configuration #
#======================#

variable "force_destroy" {
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}
variable "kms_key" {
  description = "The ID of a KMS Key to be used for encrypting the bucket"
  type        = string
  default     = null
}
variable "policy" {
  description = "A resource policy to be applied to the bucket"
  type        = string
  default     = null
}
variable "server_side_encryption_enabled" {
  description = "Specifies whether or not to enable server side encryption"
  type        = bool
  default     = false
}
variable "versioning_enabled" {
  description = "Specifies whether or not to enable bucket versioning"
  type        = bool
  default     = false
}

#======================#
# Access Control Lists #
#======================#

variable "acl" {
  description = "(Deprecated) See the `canned_acl` variable for details."
  type        = string
  default     = "private"
}
variable "canned_acl" {
  description = "(Optional, Conflicts with `access_control_policy`) The canned ACL to apply to the bucket"
  type        = string
  default     = "private"
}
variable "disable_canned_acl" {
  description = "Disable canned ACL module resource to use a `aws_s3_bucket_acl` resource outside of the module with a customer `access_control_policy`"
  type        = bool
  default     = false
}
variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket. Enabling this setting does not affect existing policies or ACLs"
  type        = bool
  default     = true
}
variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy"
  type        = bool
  default     = true
}
variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set"
  type        = bool
  default     = true
}
variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked"
  type        = bool
  default     = true
}

#============================#
# Lifecycle Configuration(s) #
#============================#

variable "create_lifecycle_rule" {
  description = "(Optional, Conflicts with `create_versioning_lifecycle_rule`) Specifies whether or not to create a lifecycle rule for transitioning storage classes for all versions"
  type        = bool
  default     = false
}
variable "create_versioning_lifecycle_rule" {
  description = "(Optional, Conflicts with `create_lifecycle_rule`) Specifies whether or not to create a lifecycle rule for transitioning storage classes and expiring non-current versions"
  type        = bool
  default     = false
}
variable "lifecycle_rule_standard_ia_days" {
  description = "Specifies the number of days after which an object's (or an object version's) storage class will be transitioned to STANDARD_IA"
  type        = number
  default     = 30
}
variable "lifecycle_rule_glacier_days" {
  description = "Specifies the number of days after which an object's (or an object version's) storage class will be transitioned to STANDARD_IA"
  type        = number
  default     = 60
}
variable "lifecycle_rule_expiration_days" {
  description = "Specifies the number of days after which an object's non-current version will be expired"
  type        = number
  default     = 180
}

#===============================#
# Replication Configurations(s) #
#===============================#

variable "create_replication_role" {
  description = "Specifies whether or not to enable bucket versioning.  If this is false"
  default     = false
}
variable "replication_configurations" {
  description = "A map of replication configuration rule objects"
  type = map(object({
    replication_role_arn       = optional(string)
    destination_account_id     = optional(string)
    destination_account_name   = string
    destination_region         = optional(string)
    destination_bucket_arn     = string
    destination_bucket_kms_arn = optional(string)
  }))
  default = {}
}

#============================#
# Notification Configuration #
#============================#

variable "bucket_notification_sns_topic_arns" {
  description = "A collection of SNS topic ARNs to publish bucket notifications to"
  type        = list(string)
  default     = []
}
variable "antivirus_role_arns" {
  description = "ARN of S3 Antivirus Lambda IAM Role"
  type        = list(string)
  default     = []
}
variable "account_admin_role_arn" {
  description = "ARN of bucket's AccountAdmin IAM Role"
  type        = string
  default     = null
}
