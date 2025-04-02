variable "is_enabled" {
  description = "Controls whether the example resources are created."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-west-2"
}

variable "domain_name" {
  description = "Name for the CodeArtifact domain created by this example."
  type        = string
  default     = "tf-repo-policy-domain-example" # Unique default name
}

variable "repository_name" {
  description = "Name for the CodeArtifact repository created by this example."
  type        = string
  default     = "tf-repo-policy-repo-example" # Unique default name
}

variable "policy_principal_arn" {
  description = "Optional ARN of the principal to grant permissions to in the repository policy. Defaults to the current caller executing Terraform."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources created by this example."
  type        = map(string)
  default = {
    Example     = "repository-advanced-with-policies"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

# --- Variables added to fix errors ---

variable "create_kms_key" {
  description = "Controls whether to create a KMS key for domain encryption (relevant for the domain created in this example)."
  type        = bool
  default     = false # Keep domain simple for this repo policy example
}

variable "kms_key_deletion_window" {
  description = "Duration in days after which the KMS key is deleted (if created)."
  type        = number
  default     = 7
}

variable "description" {
  description = "Optional description for the repository."
  type        = string
  default     = "Repository example demonstrating policy attachment"
}

variable "enable_npm_external_connection" {
  description = "Controls whether to enable the npm external connection (kept false for policy focus)."
  type        = bool
  default     = false
}

variable "create_policy" {
  description = "Controls whether to create and attach the repository permissions policy."
  type        = bool
  default     = true # Enable policy creation for this example
}

# Note: 'upstreams' variable from the module is not needed here as it defaults to null
# and isn't referenced in the current main.tf/outputs.tf boilerplate.
