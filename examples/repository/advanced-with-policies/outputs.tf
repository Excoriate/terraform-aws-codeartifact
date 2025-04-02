# This file defines the outputs exposed by the advanced-with-policies repository example.
# It includes outputs for the domain created in main.tf and mirrors outputs from the repository module.

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
  value       = var.is_enabled ? module.this.repository_arn : null
}

output "repository_name" {
  description = "The name of the created CodeArtifact repository (from module)."
  value       = var.is_enabled ? module.this.repository_name : null
}

output "repository_administrator_account" {
  description = "The AWS account ID that owns the repository (from module)."
  value       = var.is_enabled ? module.this.repository_administrator_account : null
}

output "repository_domain_owner" {
  description = "The AWS account ID that owns the domain associated with the repository (from module)."
  value       = var.is_enabled ? module.this.repository_domain_owner : null
}

output "policy_revision" {
  description = "The revision of the repository permissions policy applied by the module. Only set if a policy was created."
  value       = var.is_enabled ? module.this.policy_revision : null
  sensitive   = true
}

output "is_enabled" {
  description = "Indicates whether the example resources were enabled and created."
  value       = var.is_enabled
}

# Note: KMS key output is removed as KMS key creation is disabled by default (var.create_kms_key = false)
# in variables.tf for this specific example. If KMS were enabled, its output would be added here.
