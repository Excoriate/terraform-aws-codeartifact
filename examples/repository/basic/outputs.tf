# This file defines the outputs exposed by the basic repository example.
# It mirrors the outputs from the underlying repository module.

output "repository_arn" {
  description = "The ARN of the created CodeArtifact repository."
  value       = module.this.repository_arn
}

output "repository_name" {
  description = "The name of the created CodeArtifact repository."
  value       = module.this.repository_name
}

output "repository_administrator_account" {
  description = "The AWS account ID that owns the repository."
  value       = module.this.repository_administrator_account
}

output "repository_domain_owner" {
  description = "The AWS account ID that owns the domain."
  value       = module.this.repository_domain_owner
}

output "policy_revision" {
  description = "The revision of the repository permissions policy. Only set if a policy is created."
  value       = module.this.policy_revision
  sensitive   = true
}
