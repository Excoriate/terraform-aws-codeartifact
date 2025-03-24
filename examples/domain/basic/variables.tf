variable "is_enabled" {
  description = "Controls whether module resources should be created or not."
  type        = bool
  default     = true
}

variable "enable_domain_permissions_policy" {
  description = "Controls whether to create a domain permissions policy."
  type        = bool
  default     = true
}
