variable "is_enabled" {
  description = "Controls whether the example resources (including the module call) are created."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The name of the CodeArtifact domain to create."
  type        = string
  default     = "example-domain"
}

variable "repository_name" {
  description = "The name for the CodeArtifact repository being created by the example."
  type        = string
  default     = "my-basic-repository-example"
}

variable "aws_region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-west-2" # Or another suitable default
}

variable "tags" {
  description = "Tags to apply to all resources created by this example."
  type        = map(string)
  default = {
    Example     = "basic-repository"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

# Optional KMS key for domain encryption
variable "create_kms_key" {
  description = "Controls whether to create a KMS key for domain encryption."
  type        = bool
  default     = false
}

variable "kms_key_deletion_window" {
  description = "Duration in days after which the KMS key is deleted after destruction of the resource."
  type        = number
  default     = 7
}

# Optional description for the repository
variable "description" {
  description = "Optional description for the repository."
  type        = string
  default     = "Basic repository example created by Terraform"
}

# Optional upstream repository configuration
variable "create_upstream_repository" {
  description = "Controls whether to create an upstream repository."
  type        = bool
  default     = false
}

# Optional external connection configuration
variable "enable_npm_external_connection" {
  description = "Controls whether to enable the npm external connection."
  type        = bool
  default     = false
}

# Optional repository policy configuration
variable "create_policy" {
  description = "Controls whether to create a repository permissions policy."
  type        = bool
  default     = false
}

// Optional module variables are intentionally omitted here for a basic example.
// The module's internal defaults (null) will be used.
// They can be defined here and controlled via fixtures if needed for more complex "basic" scenarios,
// but are removed for maximum simplicity initially.
