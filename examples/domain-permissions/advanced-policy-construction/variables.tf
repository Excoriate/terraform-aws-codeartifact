variable "is_enabled" {
  description = "Controls whether the example resources (including the module call) are created."
  type        = bool
  default     = true
}

variable "domain_name_suffix" {
  description = "A suffix to append to the domain name created by this example to ensure uniqueness."
  type        = string
  default     = "dynamic-policy" # Default suffix for this example set
}

variable "aws_region" {
  description = "AWS region for the provider and resources."
  type        = string
  default     = "us-west-2"
}

# ------------------------------------------------------------------------------
# Variables passed through to the domain-permissions module
# These are typically controlled by the fixture files (*.tfvars)
# Defaults here are set to empty/null to allow fixtures to take precedence
# or test the module's internal defaults.
# ------------------------------------------------------------------------------

variable "domain_owner" {
  description = "Optional domain owner account ID for the module. If null, the module uses the current caller's account ID."
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
  description = "Optional override policy document for the module. If set, dynamic inputs are ignored."
  type        = string
  default     = null
}
