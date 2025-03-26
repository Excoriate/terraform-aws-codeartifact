variable "is_enabled" {
  description = "Controls whether the example resources (including the module call) are created."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The name of the CodeArtifact domain to apply policy to. This domain must exist."
  type        = string
  # No default - must be provided via tfvars.
}

variable "region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-west-2" # Or another suitable default
}

# Variables to pass through to the domain-permissions module, controlled by fixtures
variable "domain_owner" {
  description = "Optional domain owner account ID for the module."
  type        = string
  default     = null
}

variable "read_principals" {
  description = "Optional list of principals for baseline read access (GetDomainPermissionsPolicy)."
  type        = list(string)
  default     = []
}

variable "list_repo_principals" {
  description = "Optional list of principals for baseline list repositories access."
  type        = list(string)
  default     = []
}

variable "authorization_token_principals" {
  description = "Optional list of principals for baseline GetAuthorizationToken access."
  type        = list(string)
  default     = []
}

variable "custom_policy_statements" {
  description = "Optional list of custom policy statements for the module."
  type        = list(any)
  default     = []
}

variable "policy_revision" {
  description = "Optional policy revision for optimistic locking."
  type        = string
  default     = null
}

variable "policy_document_override" {
  description = "Optional override policy document for the module."
  type        = string
  default     = null
}
