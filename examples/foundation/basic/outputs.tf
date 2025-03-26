###################################
# Example Outputs 📤
###################################

output "is_enabled" {
  description = "Whether the module is enabled or not."
  value       = module.this.is_enabled
}

output "feature_flags" {
  description = "The feature flags set for the module."
  value       = module.this.feature_flags
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

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias"
  value       = module.this.kms_key_alias_arn
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

output "s3_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = module.this.s3_bucket_regional_domain_name
}

###################################
# OIDC Outputs 🔑
###################################

output "oidc_provider_arn" {
  description = "The ARN of the created IAM OIDC Provider (if enabled)."
  value       = module.this.oidc_provider_arn
}

output "oidc_role_arn" {
  description = "The ARN of the created IAM Role for OIDC Federation (if enabled)."
  value       = module.this.oidc_role_arn
}

output "oidc_role_name" {
  description = "The name of the created IAM Role for OIDC Federation (if enabled)."
  value       = module.this.oidc_role_name
}
