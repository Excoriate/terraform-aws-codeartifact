variable "is_enabled" {
  description = "Controls whether module resources should be created or not."
  type        = bool
  default     = true
}

variable "domain_owner" {
  description = "The AWS account ID that owns the domain. If not specified, the current account ID is used."
  type        = string
  default     = null
}

variable "policy_type" {
  description = "Type of policy to apply (none, read_only, default, admin)."
  type        = string
  default     = "default"
  validation {
    condition     = contains(["none", "read_only", "default", "admin"], var.policy_type)
    error_message = "The policy_type must be one of: none, read_only, default, admin."
  }
}

variable "principal_arn" {
  description = "ARN of the principal (user/role) to allow in the policy. If not specified, the current account ID is used."
  type        = string
  default     = null
}

variable "policy_revision" {
  description = "The current revision of the resource policy to be set."
  type        = string
  default     = null
}
