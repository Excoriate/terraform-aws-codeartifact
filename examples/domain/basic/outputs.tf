output "domain_arn" {
  description = "The ARN of the CodeArtifact domain."
  value       = module.this.domain_arn
}

output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = module.this.domain_name
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = module.this.domain_owner
}

output "domain_repository_count" {
  description = "The number of repositories in the CodeArtifact domain."
  value       = module.this.domain_repository_count
}

output "domain_encryption_key" {
  description = "The ARN of the KMS key used to encrypt the domain's assets."
  value       = module.this.domain_encryption_key
}

output "domain_created_time" {
  description = "The time the domain was created."
  value       = module.this.domain_created_time
}

output "domain_asset_size_bytes" {
  description = "The total size of all assets in the domain, in bytes."
  value       = module.this.domain_asset_size_bytes
}

output "domain_endpoint" {
  description = "The endpoint of the domain."
  value       = module.this.domain_endpoint
}

output "is_enabled" {
  description = "Whether the domain module is enabled or not."
  value       = module.this.is_enabled
}
