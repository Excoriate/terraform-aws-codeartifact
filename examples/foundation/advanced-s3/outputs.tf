###################################
# Example Outputs 📤
# ----------------------------------------------------
# Outputs from the foundation module call, plus any
# resources created directly by this example.
###################################

output "is_enabled" {
  description = "Whether the foundation module was enabled."
  value       = module.this.is_enabled
}

output "feature_flags" {
  description = "The feature flags set for the foundation module."
  value       = module.this.feature_flags
}

###################################
# KMS Key Outputs 🔐
###################################
output "kms_key_arn" {
  description = "The ARN of the KMS key created by the foundation module (if enabled)."
  value       = module.this.kms_key_arn
}

output "kms_key_id" {
  description = "The ID of the KMS key created by the foundation module (if enabled)."
  value       = module.this.kms_key_id
}

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias created by the foundation module (if enabled)."
  value       = module.this.kms_key_alias_arn
}

output "kms_key_alias_name" {
  description = "The name of the KMS key alias created by the foundation module (if enabled)."
  value       = module.this.kms_key_alias_name
}

###################################
# CloudWatch Log Group Outputs 📝
###################################
output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group created by the foundation module (if enabled)."
  value       = module.this.log_group_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group created by the foundation module (if enabled)."
  value       = module.this.log_group_name
}

###################################
# S3 Bucket Outputs (Source Bucket) 🪣
###################################
output "source_s3_bucket_id" {
  description = "The name (ID) of the source S3 bucket created by the foundation module (if enabled)."
  value       = module.this.s3_bucket_id
}

output "source_s3_bucket_arn" {
  description = "The ARN of the source S3 bucket created by the foundation module (if enabled)."
  value       = module.this.s3_bucket_arn
}

output "source_s3_bucket_domain_name" {
  description = "The domain name of the source S3 bucket created by the foundation module (if enabled)."
  value       = module.this.s3_bucket_domain_name
}

output "source_s3_bucket_regional_domain_name" {
  description = "The regional domain name of the source S3 bucket created by the foundation module (if enabled)."
  value       = module.this.s3_bucket_regional_domain_name
}

###################################
# OIDC Outputs 🔑 (Null if OIDC disabled in module call)
###################################

output "oidc_provider_arn" {
  description = "The ARN of the IAM OIDC Provider created/used by the foundation module (if enabled)."
  value       = module.this.oidc_provider_arn
}

output "oidc_role_arns" {
  description = "Map of created OIDC IAM Role names to their ARNs from the foundation module (if enabled)."
  value       = module.this.oidc_role_arns
}

output "oidc_role_names" {
  description = "Map of created OIDC IAM Role names to their names from the foundation module (if enabled)."
  value       = module.this.oidc_role_names
}

###################################
# Example-Specific Outputs (Replica Bucket & Role) ✨
###################################

output "replica_s3_bucket_id" {
  description = "The name (ID) of the replica S3 bucket created via the foundation module."
  value       = module.replica_foundation.s3_bucket_id
}

output "replica_s3_bucket_arn" {
  description = "The ARN of the replica S3 bucket created via the foundation module."
  value       = module.replica_foundation.s3_bucket_arn
}

output "replication_iam_role_arn" {
  description = "The ARN of the IAM role created by this example for S3 replication."
  # value       = aws_iam_role.replication.arn
  value = join("", [for k, v in aws_iam_role.replication : v.arn])
}

output "replication_iam_role_name" {
  description = "The name of the IAM role created by this example for S3 replication."
  # value       = aws_iam_role.replication.name
  value = join("", [for k, v in aws_iam_role.replication : v.name])
}
