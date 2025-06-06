# This file defines the outputs exposed by the advanced-policy-override example.
# It mirrors the outputs from the underlying domain-permissions module.

output "policy_revision" {
  description = "The current revision of the domain permissions policy from the module."
  value       = var.is_enabled ? module.this[0].policy_revision : null
}

output "resource_arn" {
  description = "The ARN of the domain permissions policy resource from the module."
  value       = var.is_enabled ? module.this[0].resource_arn : null
}

output "policy_document" {
  description = "The final JSON policy document applied to the domain by the module (should match the override)."
  value       = var.is_enabled ? module.this[0].policy_document : null
}

output "is_enabled" {
  description = "Indicates whether the example and the module call were enabled."
  value       = var.is_enabled
}

output "domain_name" {
  description = "The name of the CodeArtifact domain the policy applies to, from the module."
  value       = var.is_enabled ? module.this[0].domain_name : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain used by the policy, from the module."
  value       = var.is_enabled ? module.this[0].domain_owner : null
}
