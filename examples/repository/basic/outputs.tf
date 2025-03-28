# This file defines the outputs exposed by the basic repository example.
# It includes outputs for both the domain and repository resources

# Domain outputs
output "domain_name" {
  description = "The name of the created CodeArtifact domain."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].domain : null
}

output "domain_arn" {
  description = "The ARN of the created CodeArtifact domain."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].arn : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the domain."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].owner : null
}

output "domain_repository_count" {
  description = "The number of repositories in the domain."
  value       = var.is_enabled ? aws_codeartifact_domain.this[0].repository_count : null
}

# KMS key output
output "kms_key_arn" {
  description = "The ARN of the KMS key used for domain encryption (if created)."
  value       = var.is_enabled && var.create_kms_key ? aws_kms_key.this[0].arn : null
}

# Repository outputs from the module
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

# Upstream repository output
output "upstream_repository_arn" {
  description = "The ARN of the created upstream repository (if created)."
  value       = var.is_enabled && var.create_upstream_repository ? aws_codeartifact_repository.upstream[0].arn : null
}

# Repository endpoint output
output "npm_repository_endpoint" {
  description = "The endpoint URL for the npm package format (if enabled)."
  value       = var.is_enabled && var.enable_npm_external_connection ? data.aws_codeartifact_repository_endpoint.npm[0].repository_endpoint : null
}

# Policy outputs
output "policy_revision" {
  description = "The revision of the repository permissions policy. Only set if a policy is created."
  value       = module.this.policy_revision
  sensitive   = true
}
