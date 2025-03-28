variable "is_enabled" {
  description = "Controls whether the example resources (including the module call) are created."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The name of the CodeArtifact domain to apply the override policy to. This domain must exist."
  type        = string
  # No default - must be provided via tfvars.
}

variable "aws_region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-west-2" # Or another suitable default
}

# Add domain_owner as it's used in the module, even if not explicitly set in this override example's fixtures
variable "domain_owner" {
  description = "Optional domain owner account ID for the module."
  type        = string
  default     = null
}

# Include other module variables with defaults, even though they are ignored when override is used,
# to prevent potential "unexpected attribute" errors if fixtures are copied/modified later.
variable "read_principals" {
  description = "(Ignored by this example) Optional list of principals for baseline read access."
  type        = list(string)
  default     = []
}

variable "list_repo_principals" {
  description = "(Ignored by this example) Optional list of principals for baseline list repositories access."
  type        = list(string)
  default     = []
}

variable "authorization_token_principals" {
  description = "(Ignored by this example) Optional list of principals for baseline GetAuthorizationToken access."
  type        = list(string)
  default     = []
}

variable "custom_policy_statements" {
  description = "(Ignored by this example) Optional list of custom policy statements for the module."
  type        = list(any)
  default     = []
}

variable "policy_revision" {
  description = "Optional policy revision for optimistic locking."
  type        = string
  default     = null
}
