output "example_domain_arn" {
  description = "ARN of the CodeArtifact domain created by the example."
  value       = join("", [for d in aws_codeartifact_domain.example : d.arn])
}

output "example_domain_name" {
  description = "Name of the CodeArtifact domain created by the example."
  value       = join("", [for d in aws_codeartifact_domain.example : d.domain])
}

output "example_domain_owner" {
  description = "Owner of the CodeArtifact domain created by the example."
  value       = join("", [for d in aws_codeartifact_domain.example : d.owner])
}

output "cross_account_role_arn" {
  description = "ARN of the IAM role created by the module for cross-account access."
  value       = module.this.cross_account_role_arn
}

output "cross_account_role_name" {
  description = "Name of the IAM role created by the module for cross-account access."
  value       = module.this.cross_account_role_name
}

output "cross_account_role_id" {
  description = "The stable and unique ID of the created cross-account IAM role."
  value       = module.this.cross_account_role_id
}

output "cross_account_role_unique_id" {
  description = "The unique ID assigned by AWS to the created cross-account IAM role."
  value       = module.this.cross_account_role_unique_id
}

output "policy_arns" {
  description = "A list of ARNs for the IAM policies created and attached to the role."
  value       = module.this.policy_arns
}

output "module_enabled" {
  description = "Indicates whether the module created resources."
  value       = module.this.module_enabled
}
