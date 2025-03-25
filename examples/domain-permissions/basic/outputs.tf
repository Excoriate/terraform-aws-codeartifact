output "domain_name" {
  description = "The name of the CodeArtifact domain."
  value       = module.this.domain_name
}

output "domain_owner" {
  description = "The AWS account ID that owns the CodeArtifact domain."
  value       = module.this.domain_owner
}

output "policy_document" {
  description = "The JSON policy document that is set as the domain permissions policy."
  value       = module.this.policy_document
}

output "policy_revision" {
  description = "The current revision of the domain permissions policy."
  value       = module.this.policy_revision
}

output "resource_arn" {
  description = "The ARN of the resource associated with the domain permissions policy."
  value       = module.this.resource_arn
}

output "is_enabled" {
  description = "Whether the domain-permissions module is enabled or not."
  value       = module.this.is_enabled
}
