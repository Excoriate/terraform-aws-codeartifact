# This file defines the outputs exposed by the basic domain-permissions example.
# It mirrors the outputs from the underlying domain-permissions module.

output "policy_revision" {
  description = "The current revision of the domain permissions policy."
  value       = module.this.policy_revision
}

output "resource_arn" {
  description = "The ARN of the domain permissions policy resource."
  value       = module.this.resource_arn
}

output "policy_document" {
  description = "The generated JSON policy document applied to the domain."
  value       = module.this.policy_document
}

output "is_enabled" {
  description = "Indicates whether the domain permissions policy resource was enabled and potentially created."
  value       = module.this.is_enabled
}

output "domain_name" {
  description = "The name of the CodeArtifact domain the policy applies to."
  value       = module.this.domain_name
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain used by the policy."
  value       = module.this.domain_owner
}
