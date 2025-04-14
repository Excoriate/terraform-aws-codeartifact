output "repository_arn" {
  description = "The ARN of the created CodeArtifact repository."
  value       = local.create_repository ? aws_codeartifact_repository.this[0].arn : null
}

output "repository_name" {
  description = "The name of the created CodeArtifact repository."
  value       = local.create_repository ? aws_codeartifact_repository.this[0].repository : null
}

output "repository_administrator_account" {
  description = "The AWS account ID that owns the repository."
  value       = local.create_repository ? aws_codeartifact_repository.this[0].administrator_account : null
}

output "repository_domain_owner" {
  description = "The AWS account ID that owns the domain."
  value       = local.create_repository ? aws_codeartifact_repository.this[0].domain_owner : null
}

output "policy_revision" {
  description = "The revision of the repository permissions policy. Only set if a policy is created."
  value       = local.create_policy ? aws_codeartifact_repository_permissions_policy.this[0].policy_revision : null
  sensitive   = true
}

output "is_enabled" {
  description = "Whether the repository is enabled."
  value       = local.create_repository
}
