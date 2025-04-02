variable "is_enabled" {
  description = "Controls whether module resources should be created or not."
  type        = bool
  default     = true
}

variable "enable_domain_permissions_policy" {
  description = "Controls whether to create a domain permissions policy."
  type        = bool
  default     = false
}

variable "domain_owner" {
  description = "The AWS account ID that owns the domain. If not specified, the current account ID is used."
  type        = string
  default     = null
}

variable "use_default_kms" {
  description = "Whether to use the default AWS KMS key instead of creating a custom key."
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-west-2"
}
