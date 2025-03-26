# This main.tf file demonstrates basic usage of the domain-permissions module.
# It calls the module located in ../../../modules/domain-permissions
# Input variables defined in variables.tf are passed to the module.
# Different configurations can be tested using .tfvars files in the fixtures/ directory
# (e.g., terraform plan -var-file=fixtures/read_only.tfvars)

# IMPORTANT PREREQUISITE: This example applies a policy to an *existing*
# CodeArtifact domain. Ensure the domain specified via var.domain_name
# (likely in a fixture file) exists in the target AWS account and region
# before running `terraform apply`.
# `terraform plan` can be run without the domain existing to see the generated policy.

module "this" {
  source = "../../../modules/domain-permissions"

  # Pass through variables controlled by the example/fixtures
  is_enabled                     = var.is_enabled
  domain_name                    = var.domain_name # Must be provided via tfvars
  domain_owner                   = var.domain_owner
  read_principals                = var.read_principals
  list_repo_principals           = var.list_repo_principals
  authorization_token_principals = var.authorization_token_principals
  custom_policy_statements       = var.custom_policy_statements
  policy_revision                = var.policy_revision
  policy_document_override       = var.policy_document_override # Pass the override variable

  # Note: The policy is now constructed internally or uses the override.
  # The module now constructs it internally based on the principal lists and custom statements.
}
