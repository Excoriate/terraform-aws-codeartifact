# This main.tf file demonstrates basic usage of the repository module.
# It calls the module located in ../../../modules/repository
# Input variables defined in variables.tf are passed to the module.
# Different configurations can be tested using .tfvars files in the fixtures/ directory
# (e.g., terraform plan -var-file=fixtures/hosted.tfvars)

module "this" {
  source = "../../../modules/repository"

  # Required inputs
  domain_name     = var.domain_name     # Must be provided via tfvars
  repository_name = var.repository_name # Uses default or tfvars override
  is_enabled      = var.is_enabled      # Controlled by fixtures

  # Only essential inputs for a basic example. Optional features rely on module defaults (null).
  # description                = null # Explicitly null or rely on module default
  # upstreams                  = null # Explicitly null or rely on module default
  # external_connections       = null # Explicitly null or rely on module default
  # repository_policy_document = null # Explicitly null or rely on module default
  tags = var.tags # Tags are common, kept for basic example
}
