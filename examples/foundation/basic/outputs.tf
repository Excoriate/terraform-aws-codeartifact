###################################
# Example Outputs 📤
# ----------------------------------------------------
#
# This file defines outputs that expose important information
# about the resources created by this example.
#
###################################

output "is_enabled" {
  description = "Whether the module is enabled"
  value       = module.this.is_enabled
}

###################################
# KMS Key Outputs 🔐
###################################
output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = module.this.kms_key_arn
}

output "kms_key_id" {
  description = "The ID of the KMS key used for encryption"
  value       = module.this.kms_key_id
}

output "kms_key_alias_name" {
  description = "The name of the KMS key alias"
  value       = module.this.kms_key_alias_name
}

###################################
# CloudWatch Log Group Outputs 📝
###################################
output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = module.this.log_group_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = module.this.log_group_name
}

###################################
# S3 Bucket Outputs 🪣
###################################
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.this.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.this.s3_bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = module.this.s3_bucket_domain_name
}
