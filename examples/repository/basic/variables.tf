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
  default     = {
    Example     = "basic-repository"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

// Add variables corresponding to optional module inputs if you want to control them via fixtures
// Example:
variable "upstreams" {
  description = "Optional upstream configuration for the repository module."
  type = optional(list(object({
    repository_name = string
  })), null)
  default = null
}

variable "external_connections" {
  description = "Optional external connections configuration for the repository module."
  type    = optional(list(string), null)
  default = null
}

variable "repository_policy_document" {
  description = "Optional policy document for the repository module."
  type    = optional(string, null)
  default = null
}

variable "description" {
  description = "Optional description for the repository module."
  type        = string
  default     = "Basic repository example created by Terraform"
}
