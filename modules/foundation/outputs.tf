###################################
# Module-Specific Outputs 🚀
# ----------------------------------------------------
#
# These outputs are specific to the functionality provided by this module.
# They offer insights and access points into the resources created or managed by this module.
#
###################################
output "is_enabled" {
  value       = var.is_enabled
  description = "Whether the module is enabled or not."
}

output "tags_set" {
  value       = var.tags
  description = "The tags set for the module."
}

output "feature_flags" {
  value = {
    is_enabled           = var.is_enabled
    is_kms_key_enabled   = local.is_kms_key_enabled
    is_log_group_enabled = local.is_log_group_enabled
    is_s3_bucket_enabled = local.is_s3_bucket_enabled
  }
  description = "The feature flags set for the module."
}

###################################
# Module Outputs 📤
# ----------------------------------------------------
#
# This section defines the outputs that will be made available
# to other Terraform configurations that use this module.
#
###################################

###################################
# KMS Key Outputs 🔐
# ----------------------------------------------------
#
# Outputs for the KMS key and alias
#
###################################
output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = try(aws_kms_key.this[0].arn, null)
}

output "kms_key_id" {
  description = "The ID of the KMS key used for encryption"
  value       = try(aws_kms_key.this[0].key_id, null)
}

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias"
  value       = try(aws_kms_alias.this[0].arn, null)
}

output "kms_key_alias_name" {
  description = "The name of the KMS key alias"
  value       = try(aws_kms_alias.this[0].name, null)
}

###################################
# CloudWatch Log Group Outputs 📝
# ----------------------------------------------------
#
# Outputs for the CloudWatch Log Group
#
###################################
output "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}

output "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}

###################################
# S3 Bucket Outputs 🪣
# ----------------------------------------------------
#
# Outputs for the S3 bucket
#
###################################
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

output "s3_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, null)
}


###################################
# OIDC Outputs 🔑
# ----------------------------------------------------
#
# Outputs for the IAM OIDC Provider and Role
#
###################################

output "oidc_provider_arn" {
  description = "The ARN of the created IAM OIDC Provider."
  value       = try(aws_iam_openid_connect_provider.oidc[0].arn, null)
}

output "oidc_role_arn" {
  description = "The ARN of the created IAM Role for OIDC Federation."
  value       = try(aws_iam_role.oidc[0].arn, null)
}

output "oidc_role_name" {
  description = "The name of the created IAM Role for OIDC Federation."
  value       = try(aws_iam_role.oidc[0].name, null)
}
