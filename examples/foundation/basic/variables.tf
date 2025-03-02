###################################
# Basic Example Variables 📝
###################################

variable "is_enabled" {
  type        = bool
  description = "Controls whether to create any resources in this module."
  default     = true
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created."
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Environment name for resource tagging and naming."
  default     = "dev"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to use for resource naming."
  default     = "codeartifact"
}

###################################
# KMS Configuration Variables
###################################
variable "kms_deletion_window_in_days" {
  type        = number
  description = "Duration in days that AWS KMS waits before permanently deleting the KMS key."
  default     = 7
}

variable "kms_key_alias" {
  type        = string
  description = "The alias for the KMS key, must begin with 'alias/'."
  default     = "alias/codeartifact-encryption"
}

###################################
# S3 Bucket Configuration Variables
###################################
variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for CodeArtifact backups and migration artifacts."
  default     = "codeartifact-artifacts-example"
}

variable "s3_bucket_force_destroy" {
  type        = bool
  description = "Controls whether the S3 bucket can be forcefully deleted even when it contains objects."
  default     = true
}

###################################
# CloudWatch Log Group Configuration Variables
###################################
variable "log_group_name" {
  type        = string
  description = "The name of the CloudWatch Log Group for CodeArtifact audit logs."
  default     = "/aws/codeartifact/audit-logs"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs."
  default     = 30
}
