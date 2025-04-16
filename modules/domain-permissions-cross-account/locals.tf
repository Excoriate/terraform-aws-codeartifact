locals {
  # Flag to enable/disable the entire module
  is_enabled = var.is_enabled

  # Feature flags for policy management
  is_iam_role_cross_account_policies_enabled = local.is_enabled && length(var.iam_role_cross_account_policies) > 0
  is_external_principals_override_enabled    = local.is_enabled && length(var.external_principals_arns_override) > 0
  is_external_principals_enabled             = local.is_enabled && length(var.external_principals) > 0

  # Normalized tags for all resources in this module
  module_tags = {
    Repository = "github.com/Excoriate/terraform-aws-codeartifact"
    Module     = "domain-permissions-cross-account"
  }

  tags = merge(local.module_tags, var.tags)
}
