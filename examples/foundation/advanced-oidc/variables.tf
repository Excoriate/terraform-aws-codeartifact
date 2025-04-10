###################################
# Advanced OIDC Example Variables 📝
###################################

variable "is_enabled" {
  type        = bool
  description = "Controls whether to create any resources in this module."
  default     = true
}

###################################
# Feature Flags
###################################
variable "is_kms_key_enabled" {
  type        = bool
  description = "Controls whether to create the KMS key and alias. Disabled by default in this OIDC-focused example."
  default     = false # Focus: OIDC only
}

variable "is_log_group_enabled" {
  type        = bool
  description = "Controls whether to create the CloudWatch Log Group. Disabled by default in this OIDC-focused example."
  default     = false # Focus: OIDC only
}

variable "is_s3_bucket_enabled" {
  type        = bool
  description = "Controls whether to create the S3 bucket. Disabled by default in this OIDC-focused example."
  default     = false # Focus: OIDC only
}

###################################
# Common Variables
###################################
variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created."
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Environment name for resource tagging and naming."
  default     = "dev-advanced" # Different default for advanced example
}

###################################
# KMS Configuration Variables
###################################
variable "kms_deletion_window_in_days" {
  type        = number
  description = "Duration in days that AWS KMS waits before permanently deleting the KMS key."
  default     = 7
}

variable "kms_key_alias" {
  type        = string
  description = "The alias for the KMS key, must begin with 'alias/'."
  default     = "alias/codeartifact-adv-oidc-encryption" # Different default
}

variable "kms_key_policy" {
  type        = string
  description = "Optional custom IAM policy for the KMS key (JSON string). If null, module default is used."
  default     = null
}

###################################
# S3 Bucket Configuration Variables
###################################
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for CodeArtifact backups and migration artifacts."
  default     = "codeartifact-artifacts-adv-oidc-example" # Different default
}

variable "s3_bucket_force_destroy" {
  type        = bool
  description = "Controls whether the S3 bucket can be forcefully deleted even when it contains objects."
  default     = true
}

variable "s3_bucket_policy_override" {
  type        = string
  description = "Optional custom bucket policy (JSON string) to override the default policy. If null, default + additional policies are used."
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
  description = "List of additional bucket policy statements to merge with the default policy (ignored if override is set)."
  default     = []
}

###################################
# CloudWatch Log Group Configuration Variables
###################################
variable "log_group_name" {
  type        = string
  description = "The name of the CloudWatch Log Group for CodeArtifact audit logs."
  default     = "/aws/codeartifact/adv-oidc-audit-logs" # Different default
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs."
  default     = 30
}

###################################
# CodeArtifact Domain Configuration
###################################
variable "codeartifact_domain_name" {
  type        = string
  description = "The name of the CodeArtifact domain to create. This provides a consistent naming convention for resources."
  default     = "adv-oidc-example-domain" # Different default
}


# --- OIDC Provider Variables (for pass-through) ---

variable "is_oidc_provider_enabled" {
  description = "Pass-through for module's is_oidc_provider_enabled."
  type        = bool
  default     = true # Default to enabled in the advanced example
}

variable "oidc_provider_url" {
  description = "Pass-through for module's oidc_provider_url."
  type        = string
  default     = null # Must be set in fixture
}

variable "oidc_client_id_list" {
  description = "Pass-through for module's oidc_client_id_list."
  type        = list(string)
  default     = ["sts.amazonaws.com"] # Default suitable for GitHub Actions fixture
}

variable "oidc_thumbprint_list" {
  description = "Pass-through for module's oidc_thumbprint_list."
  type        = list(string)
  default     = []
}

variable "oidc_roles" {
  description = "Pass-through for module's oidc_roles variable. Defines the list of IAM roles to create for OIDC federation."
  type = list(object({
    name                  = string
    description           = optional(string, "IAM role for OIDC federation")
    max_session_duration  = optional(number, 3600)
    condition_string_like = map(list(string))
    attach_policy_arns    = optional(list(string), [])
    inline_policies       = optional(map(string), {})
  }))
  default = [] # Must be set in fixture
}
