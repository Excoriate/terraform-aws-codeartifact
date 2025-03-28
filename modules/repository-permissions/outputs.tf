output "policy_revision" {
  description = "The current revision of the repository permissions policy. Useful for optimistic locking."
  value       = local.create_policy ? aws_codeartifact_repository_permissions_policy.this[0].policy_revision : null
}

output "resource_arn" {
  description = "The ARN of the repository permissions policy resource."
  value       = local.create_policy ? aws_codeartifact_repository_permissions_policy.this[0].resource_arn : null
}

output "policy_document" {
  description = "The generated JSON policy document applied to the repository."
  # Access with [0] because the data source uses count = var.is_enabled ? 1 : 0
  value = local.create_policy ? data.aws_iam_policy_document.combined[0].json : null
}

output "is_enabled" {
  description = "Indicates whether the repository permissions policy resource was enabled and potentially created."
  value       = local.is_enabled
}

output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = local.is_enabled ? var.domain_name : null
}

output "repository_name" {
  description = "The name of the CodeArtifact repository."
  value       = local.is_enabled ? var.repository_name : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = local.is_enabled ? local.effective_domain_owner : null
}
