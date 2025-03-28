# This main.tf file demonstrates basic usage of the repository-permissions module.
# It calls the module located in ../../../modules/repository-permissions
# Input variables defined in variables.tf are passed to the module.
# Different configurations can be tested using .tfvars files in the fixtures/ directory
# (e.g., terraform plan -var-file=fixtures/read_only.tfvars)

# IMPORTANT PREREQUISITE: This example applies a policy to an *existing*
# CodeArtifact domain and repository. Ensure the domain and repository specified
# via var.domain_name and var.repository_name (likely in a fixture file)
# exist in the target AWS account and region before running `terraform apply`.
# `terraform plan` can be run without the resources existing to see the generated policy.

module "this" {
  source = "../../../modules/repository-permissions"

  # Pass through variables controlled by the example/fixtures
  is_enabled                     = var.is_enabled
  domain_name                    = var.domain_name     # Must be provided via tfvars
  repository_name                = var.repository_name # Must be provided via tfvars
  domain_owner                   = var.domain_owner
  read_principals                = var.read_principals
  describe_principals            = var.describe_principals
  authorization_token_principals = var.authorization_token_principals
  custom_policy_statements       = var.custom_policy_statements
  policy_revision                = var.policy_revision
}
