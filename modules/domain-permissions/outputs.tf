output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = local.is_enabled ? var.domain_name : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = local.is_enabled ? local.effective_domain_owner : null
}

output "policy_document" {
  description = "The JSON policy document that is set as the domain permissions policy."
  value       = local.create_domain_permissions ? var.policy_document : null
}

output "policy_revision" {
  description = "The current revision of the domain permissions policy."
  value       = local.create_domain_permissions ? aws_codeartifact_domain_permissions_policy.this[0].policy_revision : null
}

output "resource_arn" {
  description = "The ARN of the resource associated with the domain permissions policy."
  value       = local.create_domain_permissions ? aws_codeartifact_domain_permissions_policy.this[0].resource_arn : null
}

output "is_enabled" {
  description = "Whether the domain-permissions module is enabled or not."
  value       = local.is_enabled
}
