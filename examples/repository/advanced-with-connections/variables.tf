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
  default     = "tf-repo-connect-domain-example" # Unique default name
}

variable "repository_name" {
  description = "Name for the CodeArtifact repository created by this example."
  type        = string
  default     = "tf-repo-connect-repo-example" # Unique default name
}

variable "external_connection" {
  description = "External connection to configure for the repository (e.g., \"public:npmjs\", \"public:pypi\"). Only one is allowed."
  type        = string
  default     = "public:npmjs" # Default to npmjs for the basic enabled case
}

variable "tags" {
  description = "Tags to apply to resources created by this example."
  type        = map(string)
  default = {
    Example     = "repository-advanced-with-connections"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}
