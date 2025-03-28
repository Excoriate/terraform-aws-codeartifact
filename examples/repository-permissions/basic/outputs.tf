# This file defines the outputs exposed by the basic repository-permissions example.
# It mirrors the outputs from the underlying repository-permissions module.

output "policy_revision" {
  description = "The current revision of the repository permissions policy. Useful for optimistic locking."
  value       = module.this.policy_revision
}

output "resource_arn" {
  description = "The ARN of the repository permissions policy resource."
  value       = module.this.resource_arn
}

output "policy_document" {
  description = "The generated JSON policy document applied to the repository."
  value       = module.this.policy_document
}

output "is_enabled" {
  description = "Indicates whether the repository permissions policy resource was enabled and potentially created."
  value       = module.this.is_enabled
}

output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = module.this.domain_name
}

output "repository_name" {
  description = "The name of the CodeArtifact repository."
  value       = module.this.repository_name
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = module.this.domain_owner
}
