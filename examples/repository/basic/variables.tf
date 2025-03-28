variable "is_enabled" {
  description = "Controls whether the example resources (including the module call) are created."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The name of the CodeArtifact domain to create the repository in. This domain must exist."
  type        = string
  # No default - must be provided, e.g., via tfvars file.
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
  description = "Tags to apply to the repository created by the module."
  type        = map(string)
  default = {
    Example     = "basic-repository"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

// Optional module variables are intentionally omitted here for a basic example.
// The module's internal defaults (null) will be used.
// They can be defined here and controlled via fixtures if needed for more complex "basic" scenarios,
// but are removed for maximum simplicity initially.
