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

  # Optional inputs controlled by example variables (and potentially tfvars)
  is_enabled                 = var.is_enabled
  description                = var.description
  upstreams                  = var.upstreams
  external_connections       = var.external_connections
  repository_policy_document = var.repository_policy_document
  tags                       = var.tags
}
