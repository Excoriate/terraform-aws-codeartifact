# This file defines the outputs exposed by the advanced-with-connections repository example.

# Domain outputs (created directly in this example)
output "domain_name" {
  description = "The name of the CodeArtifact domain created by this example."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].domain : null
}

output "domain_arn" {
  description = "The ARN of the CodeArtifact domain created by this example."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].arn : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the domain created by this example."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].owner : null
}

# Repository outputs (from the module call)
output "repository_arn" {
  description = "The ARN of the created CodeArtifact repository (from module)."
  value       = var.is_enabled ? module.this[0].repository_arn : null
}

output "repository_name" {
  description = "The name of the created CodeArtifact repository (from module)."
  value       = var.is_enabled ? module.this[0].repository_name : null
}

output "repository_administrator_account" {
  description = "The AWS account ID that owns the repository (from module)."
  value       = var.is_enabled ? module.this[0].repository_administrator_account : null
}

output "repository_domain_owner" {
  description = "The AWS account ID that owns the domain associated with the repository (from module)."
  value       = var.is_enabled ? module.this[0].repository_domain_owner : null
}

# Note: policy_revision output is omitted as this example doesn't attach a policy.

output "is_enabled" {
  description = "Indicates whether the example resources were enabled and created."
  value       = var.is_enabled
}
