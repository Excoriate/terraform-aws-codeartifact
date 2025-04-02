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
  default     = "tf-repo-upstream-domain-example" # Unique default name
}

variable "upstream_repo_name" {
  description = "Name for the upstream CodeArtifact repository."
  type        = string
  default     = "tf-repo-upstream-example" # Unique default name
}

variable "downstream_repo_name" {
  description = "Name for the downstream CodeArtifact repository that uses the upstream."
  type        = string
  default     = "tf-repo-downstream-example" # Unique default name
}

variable "policy_principal_arn" {
  description = "Optional ARN of the principal to grant permissions to in the downstream repository policy. Defaults to the current caller executing Terraform."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources created by this example."
  type        = map(string)
  default = {
    Example     = "repository-advanced-with-upstream"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}
