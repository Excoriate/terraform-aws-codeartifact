locals {
  # Flag to enable/disable the entire module
  is_enabled = var.is_enabled

  # Feature flags for policy management
  is_policies_enabled = local.is_enabled && length(var.policies) > 0

  # Normalized tags for all resources in this module
  module_tags = {
    Repository = "github.com/Excoriate/terraform-aws-codeartifact"
    Module     = "domain-permissions-cross-account"
  }

  tags = merge(local.module_tags, var.tags)
}
