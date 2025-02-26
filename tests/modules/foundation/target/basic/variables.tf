###################################
# Variables for Target Test Configuration
###################################

variable "is_enabled" {
  description = "Whether the module is enabled or not"
  type        = bool
  default     = true
}

# KMS Key configuration
variable "is_kms_key_enabled" {
  description = "Whether to create a KMS key"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 7
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "The alias for the KMS key"
  type        = string
  default     = "alias/codeartifact-test-key"
}

# CloudWatch Log Group configuration
variable "is_log_group_enabled" {
  description = "Whether to create a CloudWatch log group"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = "/aws/codeartifact/test-logs"
}

variable "log_group_retention_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 30
}

# S3 Bucket configuration
variable "is_s3_bucket_enabled" {
  description = "Whether to create an S3 bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "codeartifact-test-bucket"
}

variable "force_destroy_bucket" {
  description = "Whether to force destroy the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_versioning" {
  description = "The versioning state of the bucket"
  type        = string
  default     = "Enabled"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "codeartifact-foundation-test"
  }
}
