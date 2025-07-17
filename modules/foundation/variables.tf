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

variable "is_s3_replication_enabled" {
  type        = bool
  description = "Controls whether to enable S3 bucket replication configuration. Requires is_s3_bucket_enabled to be true. If enabled, s3_replication_role_arn and s3_replication_destination must be provided."
  default     = false
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

variable "codeartifact_domain_name" {
  type        = string
  default     = "awsca-default"
  description = <<-DESC
  The name of the CodeArtifact domain to create. If it's not set, it'll default to 'awsca-default'.
  DESC
}

variable "s3_replication_role_arn" {
  type        = string
  description = "ARN of the IAM role that S3 assumes when replicating objects. Required if is_s3_replication_enabled is true."
  default     = null

  validation {
    condition     = var.is_s3_replication_enabled == false || var.s3_replication_role_arn != null
    error_message = "s3_replication_role_arn must be provided when is_s3_replication_enabled is true."
  }
  validation {
    condition     = var.s3_replication_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/", var.s3_replication_role_arn))
    error_message = "s3_replication_role_arn must be a valid IAM role ARN."
  }
}

variable "s3_replication_destination" {
  type = object({
    bucket_arn    = string
    storage_class = optional(string, "STANDARD")
    # Future options like metrics, encryption_configuration could be added here
  })
  description = "Configuration for the replication destination bucket. `bucket_arn` is required. `storage_class` defaults to STANDARD."
  default     = null

  validation {
    condition     = var.is_s3_replication_enabled == false || var.s3_replication_destination != null
    error_message = "s3_replication_destination must be provided when is_s3_replication_enabled is true."
  }
  validation {
    # Validate bucket_arn format within the object
    condition     = var.s3_replication_destination == null || can(regex("^arn:aws:s3:::", var.s3_replication_destination.bucket_arn))
    error_message = "s3_replication_destination.bucket_arn must be a valid S3 bucket ARN (e.g., arn:aws:s3:::bucket-name)."
  }
  # Add validation for storage_class if needed, e.g., check against allowed values
}

###################################
# Common Tags Variables 🏷️
###################################
variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources created by this module. These tags will be applied to all resources that support tagging, helping with resource organization, cost allocation, and access control. Tags should follow your organization's tagging strategy and might include values for environment, project, owner, or other relevant categories."
  default     = {}
}


###################################
# OIDC Provider Variables 🔑
###################################

variable "is_oidc_provider_enabled" {
  description = <<-DESC
    Controls whether to create the IAM OIDC identity provider and associated roles
    for federated access (e.g., from GitLab CI/CD or GitHub Actions).
    Set to `true` to enable this functionality.
  DESC
  type        = bool
  default     = false
}

variable "oidc_use_existing_provider" {
  description = "If true, the module will use an existing OIDC provider found via the oidc_provider_url data source instead of creating a new one."
  type        = bool
  default     = false
}

variable "oidc_provider_url" {
  description = <<-DESC
    The URL of the OIDC identity provider (e.g., `https://gitlab.com` or `https://token.actions.githubusercontent.com`).
    Required if `is_oidc_provider_enabled` is true. Must include `https://`.
  DESC
  type        = string
  default     = null # Required if enabled

  validation {
    condition     = var.is_oidc_provider_enabled == false || (var.oidc_provider_url != null && can(regex("^https://", var.oidc_provider_url)))
    error_message = "If OIDC provider is enabled, oidc_provider_url must be provided and start with 'https://'."
  }
}

variable "oidc_client_id_list" {
  description = <<-DESC
    List of client IDs (audiences) registered with the OIDC provider.
    For GitHub Actions, typically `["sts.amazonaws.com"]`.
    For GitLab, often the GitLab instance URL (e.g., `["https://gitlab.com"]`) or specific application IDs.
  DESC
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "oidc_thumbprint_list" {
  description = <<-DESC
    Optional list of server certificate thumbprints for the OIDC provider. If empty, Terraform will attempt
    to automatically fetch the thumbprint from the provider's URL using the tls_certificate data source.
    AWS might ignore this for well-known providers like GitHub/GitLab. Provide explicitly if needed for other providers or specific CAs.
  DESC
  type        = list(string)
  default     = []
}

variable "oidc_roles" {
  description = <<-DESC
  List of OIDC roles to create, associated with the OIDC provider. Each object in the list defines a role.
  - `name`: (Required) The name for the IAM role.
  - `description`: (Optional) Description for the IAM role.
  - `max_session_duration`: (Optional) Maximum session duration in seconds (3600-43200). Defaults to 3600.
  - `condition_string_like`: (Required) Map defining the StringLike conditions for the AssumeRoleWithWebIdentity policy statement.
      Keys are condition variables (e.g., `gitlab.com:sub`), values are lists of allowed patterns.
      Example for GitLab: `{"gitlab.com:sub" = ["project_path:yourgroup/yourproject:ref_type:branch:ref:main"]}`
      Example for GitHub: `{"token.actions.githubusercontent.com:sub" = ["repo:yourorg/yourrepo:ref:refs/heads/main"]}`
  - `attach_policy_arns`: (Optional) List of managed IAM policy ARNs to attach to this role. Defaults to empty list.
  - `inline_policies`: (Optional) Map of inline IAM policies to attach to this role. Keys are policy names, values are policy JSON strings. Defaults to empty map.
  DESC
  type = list(object({
    name                  = string
    description           = optional(string, "IAM role for OIDC federation")
    max_session_duration  = optional(number, 3600)
    condition_string_like = map(list(string))
    attach_policy_arns    = optional(list(string), [])
    inline_policies       = optional(map(string), {})
  }))
  default = []

  validation {
    # Check if OIDC is enabled, then roles must be provided if enabled.
    condition     = var.is_oidc_provider_enabled == false || length(var.oidc_roles) > 0
    error_message = "If is_oidc_provider_enabled is true, at least one role must be defined in oidc_roles."
  }

  validation {
    # Validate attributes within each role object
    condition = alltrue([
      for role in var.oidc_roles : (
        # Validate name (basic check, IAM has stricter rules applied at creation)
        can(regex("^[\\w+=,.@-]+$", role.name)) &&
        # Validate max_session_duration
        role.max_session_duration >= 3600 && role.max_session_duration <= 43200 &&
        # Validate condition_string_like is not empty
        length(keys(role.condition_string_like)) > 0 &&
        # Validate attach_policy_arns format
        alltrue([for arn in role.attach_policy_arns : can(regex("^arn:aws:iam::([0-9]{12}|aws):policy/", arn))]) &&
        # Validate inline_policies JSON format
        alltrue([for policy_json in values(role.inline_policies) : can(jsondecode(policy_json))])
      )
    ])
    error_message = "Validation failed for one or more roles in oidc_roles. Check name format, max_session_duration (3600-43200), ensure condition_string_like is provided, attach_policy_arns format, and inline_policies JSON validity."
  }
}
