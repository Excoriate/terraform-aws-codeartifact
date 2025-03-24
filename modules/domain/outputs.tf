output "domain_arn" {
  description = "The ARN of the CodeArtifact domain."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].arn : null
}

output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].domain : null
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].owner : null
}

output "domain_repository_count" {
  description = "The number of repositories in the CodeArtifact domain."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].repository_count : null
}

output "domain_encryption_key" {
  description = "The ARN of the KMS key used to encrypt the domain's assets."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].encryption_key : null
}

output "domain_created_time" {
  description = "The time the domain was created."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].created_time : null
}

output "domain_asset_size_bytes" {
  description = "The total size of all assets in the domain, in bytes."
  value       = local.create_domain ? aws_codeartifact_domain.this[0].asset_size_bytes : null
}

output "domain_endpoint" {
  description = "The endpoint of the domain."
  value       = local.create_domain ? "https://${aws_codeartifact_domain.this[0].domain}-${local.effective_domain_owner}.d.codeartifact.${data.aws_region.current.name}.amazonaws.com" : null
}

output "is_enabled" {
  description = "Whether the domain module is enabled or not."
  value       = local.is_enabled
}
