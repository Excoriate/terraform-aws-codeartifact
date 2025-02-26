###################################
# Outputs for Target Test Configuration
###################################

output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = module.foundation.kms_key_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = module.foundation.kms_key_arn
}

output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.foundation.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.foundation.s3_bucket_arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = module.foundation.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = module.foundation.cloudwatch_log_group_arn
}

output "is_enabled" {
  description = "Whether the module is enabled"
  value       = var.is_enabled
}
