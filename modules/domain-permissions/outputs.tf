output "policy_revision" {
  description = "The current revision of the domain permissions policy."
  value       = local.create_policy ? aws_codeartifact_domain_permissions_policy.this[0].policy_revision : null
}

output "feature_flags" {
  description = "The feature flags for the domain permissions policy."
  value = {
    is_enabled                 = local.is_enabled
    is_built_in_policy_enabled = local.is_built_in_policy_enabled
  }
}

output "resource_arn" {
  description = "The ARN of the domain permissions policy resource."
  value       = local.create_policy ? aws_codeartifact_domain_permissions_policy.this[0].resource_arn : null
}

output "policy_document" {
  description = "The final JSON policy document applied to the domain (either override or generated)."
  value       = local.final_policy_document # This local already handles null if create_policy is false
}

output "is_enabled" {
  description = "Indicates whether the domain permissions policy resource was enabled and potentially created."
  value       = local.is_enabled
}

output "domain_name" {
  description = "The name of the CodeArtifact domain the policy applies to."
  value       = local.is_enabled ? var.domain_name : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain used by the policy."
  value       = local.is_enabled ? local.effective_domain_owner : null
}
