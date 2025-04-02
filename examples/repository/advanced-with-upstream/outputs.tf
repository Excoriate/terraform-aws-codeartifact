# This file defines the outputs exposed by the advanced-with-upstream repository example.

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

# Upstream Repository outputs (from module.repo_upstream)
output "upstream_repository_arn" {
  description = "The ARN of the created upstream CodeArtifact repository."
  value       = var.is_enabled ? module.repo_upstream[0].repository_arn : null
}

output "upstream_repository_name" {
  description = "The name of the created upstream CodeArtifact repository."
  value       = var.is_enabled ? module.repo_upstream[0].repository_name : null
}

# Downstream Repository outputs (from module.repo_downstream)
output "downstream_repository_arn" {
  description = "The ARN of the created downstream CodeArtifact repository."
  value       = var.is_enabled ? module.repo_downstream[0].repository_arn : null
}

output "downstream_repository_name" {
  description = "The name of the created downstream CodeArtifact repository."
  value       = var.is_enabled ? module.repo_downstream[0].repository_name : null
}

output "downstream_policy_revision" {
  description = "The revision of the repository permissions policy applied to the downstream repository. Only set if a policy was created."
  value       = var.is_enabled ? module.repo_downstream[0].policy_revision : null
  sensitive   = true # Mark as sensitive as requested
}

output "is_enabled" {
  description = "Indicates whether the example resources were enabled and created."
  value       = var.is_enabled
}
