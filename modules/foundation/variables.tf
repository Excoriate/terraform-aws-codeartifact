###################################
# Module Variables 📝
# ----------------------------------------------------
#
# This section defines the variables that can be customized when
# using this module. Each variable includes a description of its
# purpose and any validation rules that apply.
#
###################################

###################################
# Module Feature Flags 🎯
###################################
variable "is_enabled" {
  type        = bool
  description = "Controls whether to create any resources in this module. When set to false, no resources will be created regardless of other variable settings. This is useful for conditional resource creation or temporary resource disablement without removing the module configuration."
  default     = true
}

variable "is_kms_key_enabled" {
  type        = bool
  description = <<-DESC
  Controls whether to create the KMS key and alias for CodeArtifact encryption.
  When enabled, a dedicated KMS key will be created for encrypting CodeArtifact artifacts
  and related resources. This key will also be used for S3 bucket encryption if both
  KMS and S3 features are enabled.

  Default: true (creates KMS key and alias)
  DESC
  default     = true
}

variable "is_log_group_enabled" {
  type        = bool
  description = <<-DESC
  Controls whether to create the CloudWatch Log Group for CodeArtifact audit logs.
  When enabled, a dedicated log group will be created to store and manage CodeArtifact
  audit logs with the specified retention period. If KMS encryption is also enabled,
  the logs will be encrypted using the created KMS key.

  Default: true (creates CloudWatch Log Group)
  DESC
  default     = true
}

variable "is_s3_bucket_enabled" {
  type        = bool
  description = <<-DESC
  Controls whether to create the S3 bucket for CodeArtifact backups and artifacts.
  When enabled, a dedicated S3 bucket will be created with versioning enabled and
  public access blocked. If KMS encryption is also enabled, the bucket will use
  the created KMS key for encryption.

  Default: true (creates S3 bucket)
  DESC
  default     = true
}

###################################
# KMS Key Variables 🔐
###################################
variable "kms_key_deletion_window" {
  type        = number
  description = "Specifies the duration in days that AWS KMS waits before permanently deleting the KMS key. This waiting period provides a safeguard against accidental deletion by allowing time for key recovery if needed. The value must be between 7 and 30 days, with a recommended minimum of 7 days to ensure adequate time for key recovery in case of accidental deletion."
  default     = 7

  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "The KMS key deletion window must be between 7 and 30 days."
  }
}

variable "kms_key_alias" {
  type        = string
  description = "Specifies the display name for the KMS key. The alias makes it easier to identify the key's purpose and manage it in the AWS Console. The alias name must begin with 'alias/' followed by a name that helps identify the key's purpose, such as 'alias/codeartifact-encryption'. This alias will be used consistently across the AWS account to reference this specific KMS key."

  validation {
    condition     = can(regex("^alias/", var.kms_key_alias))
    error_message = "The KMS key alias must begin with 'alias/'."
  }
}

variable "kms_key_policy" {
  type        = string
  description = <<-DESC
  Specifies a custom IAM policy for the KMS key. This policy controls who can use and manage the KMS key.
  If not provided, a default policy will be used that allows:
  - Root account access for key administration
  - CodeArtifact service for encryption operations
  - S3 service for encryption operations
  - CloudWatch Logs for encryption operations

  The policy should be provided as a JSON-encoded string and must follow AWS KMS key policy syntax and rules.
  See AWS documentation for KMS key policies: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html

  **IMPORTANT SECURITY CONSIDERATIONS**:
  - Ensure the policy follows the principle of least privilege
  - Include necessary permissions for key administration
  - Consider including conditions for additional security
  - Don't remove essential service permissions needed for CodeArtifact operation
  ```
  DESC
  default     = null

  validation {
    condition     = var.kms_key_policy == null ? true : can(jsondecode(var.kms_key_policy))
    error_message = "The KMS key policy must be a valid JSON string."
  }
}

###################################
# CloudWatch Log Group Variables 📝
###################################
variable "log_group_retention_days" {
  type        = number
  description = "Determines how long CloudWatch Logs retains log events in the specified log group. This setting helps manage storage costs while ensuring compliance with data retention requirements. The retention period can be set from 1 day to 10 years (3650 days). Common retention periods are 30 days for operational logs, 90 days for compliance, or longer for audit purposes. After the specified period, CloudWatch Logs automatically deletes expired log events."
  default     = 30

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_group_retention_days)
    error_message = "Log group retention days must be one of [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]."
  }
}

variable "log_group_name" {
  type        = string
  description = "Defines the name of the CloudWatch Log Group where CodeArtifact audit logs will be stored. The name should be descriptive and follow your organization's naming conventions. For example, '/aws/codeartifact/audit-logs' clearly indicates the purpose of the log group. This name will be used to identify and access the logs in CloudWatch, so choose a name that makes it easy to find and manage the logs."
}

###################################
# S3 Bucket Variables 🪣
###################################
variable "s3_bucket_name" {
  type        = string
  description = "Specifies the name of the S3 bucket that will store CodeArtifact backups and migration artifacts. The bucket name must be globally unique across all AWS accounts and regions. It should follow AWS S3 naming rules: use only lowercase letters, numbers, dots (.), and hyphens (-), start with a letter or number, and be between 3 and 63 characters long. Choose a name that reflects the bucket's purpose and your organization's naming scheme."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.s3_bucket_name))
    error_message = "S3 bucket name must be between 3 and 63 characters, start and end with a letter or number, and contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "force_destroy_bucket" {
  type        = bool
  description = "Controls whether the S3 bucket can be forcefully deleted even when it contains objects. When set to true, all objects (including all versions and delete markers) in the bucket will be deleted automatically when the bucket is destroyed. This is useful for development environments or when you're certain that the bucket contents can be deleted. However, use this option with caution in production environments to prevent accidental data loss."
  default     = false
}

variable "s3_bucket_policy_override" {
  type        = string
  description = <<-DESC
  Optional custom bucket policy to override the default policy. This should be a valid JSON-encoded policy.
  When provided, this policy will completely replace the default bucket policy.

  **IMPORTANT NOTES**:
  - This policy must be a valid S3 bucket policy document
  - The policy must include necessary principal and resource configurations
  - If provided, this overrides all other policy configurations

  **USAGE EXAMPLE**:
  ```hcl
  s3_bucket_policy_override = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::ACCOUNT-ID:root"]
        }
        Action    = ["s3:GetObject", "s3:ListBucket"]
        Resource  = ["arn:aws:s3:::BUCKET-NAME/*"]
      }
    ]
  })
  ```
  DESC
  default     = null
}

variable "additional_bucket_policies" {
  type = list(object({
    sid     = string
    effect  = string
    actions = list(string)
    principals = object({
      type        = string
      identifiers = list(string)
    })
    resources = list(string)
    condition = optional(map(map(string)), null)
  }))
  description = <<-DESC
  List of additional bucket policy statements to be added to the default bucket policy.
  This allows extending the default policy without completely replacing it.

  **STRUCTURE**:
  - sid: Unique statement identifier
  - effect: "Allow" or "Deny"
  - actions: List of S3 actions
  - principals: IAM principals to grant access
    - type: Principal type (e.g., "AWS", "Service")
    - identifiers: List of principal identifiers
  - resources: List of S3 resource ARNs
  - condition: Optional condition block (map of condition operators to values)

  **USAGE EXAMPLE**:
  ```hcl
  additional_bucket_policies = [
    {
      sid     = "AllowCrossAccountAccess"
      effect  = "Allow"
      actions = ["s3:GetObject", "s3:ListBucket"]
      principals = {
        type        = "AWS"
        identifiers = ["arn:aws:iam::ACCOUNT-ID:root"]
      }
      resources = ["arn:aws:s3:::BUCKET-NAME/*"]
    }
  ]
  ```
  DESC
  default     = []

  validation {
    condition     = alltrue([for p in var.additional_bucket_policies : can(regex("^[A-Za-z0-9-_]+$", p.sid))])
    error_message = "All policy statement IDs (sid) must be alphanumeric with optional underscores or hyphens."
  }

  validation {
    condition     = alltrue([for p in var.additional_bucket_policies : contains(["Allow", "Deny"], p.effect)])
    error_message = "Policy effect must be either 'Allow' or 'Deny'."
  }
}

variable "bucket_name" {
  type        = string
  description = <<-DESC
  Name of the S3 bucket to create. If not provided, a default name will be generated using the pattern:
  codeartifact-[account-id]

  **NAMING CONSTRAINTS**:
  - Must be lowercase
  - Must be between 3 and 63 characters
  - Can contain only letters, numbers, dots (.), and hyphens (-)
  - Must begin and end with a letter or number
  - Must not be formatted as an IP address
  DESC
  default     = null

  validation {
    condition     = var.bucket_name == null || can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase, start and end with a letter/number, and contain only letters, numbers, dots, and hyphens."
  }
}

###################################
# Common Tags Variables 🏷️
###################################
variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources created by this module. These tags will be applied to all resources that support tagging, helping with resource organization, cost allocation, and access control. Tags should follow your organization's tagging strategy and might include values for environment, project, owner, or other relevant categories."
  default     = {}
}
