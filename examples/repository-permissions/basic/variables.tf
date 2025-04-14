variable "is_enabled" {
  description = "Master flag to enable/disable the example resources."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region where the resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Name for the CodeArtifact domain created directly in this example."
  type        = string
  default     = "repo-perms-basic-domain-example"
}

variable "repository_name" {
  description = "Name for the CodeArtifact repository created via the repository module."
  type        = string
  default     = "repo-perms-basic-repo-example"
}

variable "policy_principals" {
  description = "List of IAM principal ARNs to grant read access in the repository policy."
  type        = list(string)
  default     = [] # Default to empty, will use current caller identity in main.tf if empty
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default = {
    Environment = "example"
    Project     = "repository-permissions-basic"
    ManagedBy   = "terraform"
  }
}
