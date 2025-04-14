output "example_domain_arn" {
  description = "ARN of the CodeArtifact domain created by the example."
  value       = var.is_enabled ? aws_codeartifact_domain.example[0].arn : null
}

output "example_domain_name" {
  description = "Name of the CodeArtifact domain created by the example."
  value       = var.is_enabled ? aws_codeartifact_domain.example[0].domain : null
}

output "example_domain_owner" {
  description = "Owner of the CodeArtifact domain created by the example."
  value       = var.is_enabled ? aws_codeartifact_domain.example[0].owner : null
}

output "repository_module_repository_arn" {
  description = "ARN of the CodeArtifact repository created by the repository module."
  value       = var.is_enabled ? module.repository[0].repository_arn : null
}

output "repository_module_repository_name" {
  description = "Name of the CodeArtifact repository created by the repository module."
  value       = var.is_enabled ? module.repository[0].repository_name : null
}

output "repository_permissions_module_is_enabled" {
  description = "Indicates whether the repository permissions policy resource was enabled."
  value       = module.this.is_enabled # Note: module.this refers to repository-permissions module
}

output "repository_permissions_module_policy_document" {
  description = "The generated JSON policy document applied to the repository."
  value       = module.this.policy_document
  sensitive   = true # Policy documents can contain sensitive info
}

output "repository_permissions_module_policy_revision" {
  description = "The current revision of the repository permissions policy."
  value       = module.this.policy_revision
}

output "repository_permissions_module_resource_arn" {
  description = "The ARN of the repository permissions policy resource."
  value       = module.this.resource_arn
}
