###################################
# Module Outputs
###################################

output "cross_account_role_arn" {
  description = "ARN of the cross-account IAM role that can be assumed by external principals to access the CodeArtifact domain."
  value       = var.is_enabled ? aws_iam_role.cross_account_role["enabled"].arn : null
}

output "cross_account_role_name" {
  description = "Name of the cross-account IAM role."
  value       = var.is_enabled ? aws_iam_role.cross_account_role["enabled"].name : null
}

output "cross_account_role_id" {
  description = "The ID of the cross-account IAM role."
  value       = var.is_enabled ? aws_iam_role.cross_account_role["enabled"].id : null
}

output "cross_account_role_unique_id" {
  description = "The unique ID assigned by AWS to the cross-account IAM role."
  value       = var.is_enabled ? aws_iam_role.cross_account_role["enabled"].unique_id : null
}

output "policy_arns" {
  description = "List of ARNs of the IAM policies created for cross-account access."
  value       = var.is_enabled && local.is_iam_role_cross_account_policies_enabled ? [for policy in aws_iam_policy.policies : policy.arn] : []
}

output "module_enabled" {
  description = "Whether the module is enabled or not."
  value       = var.is_enabled
}

output "feature_flags" {
  description = "A map of feature flags used in the module."
  value = {
    is_enabled                              = local.is_enabled
    are_iam_role_cross_account_policies_set = local.is_iam_role_cross_account_policies_enabled
    are_external_principals_set             = local.is_external_principals_enabled
    are_external_principals_override_set    = local.is_external_principals_override_enabled
  }
}
