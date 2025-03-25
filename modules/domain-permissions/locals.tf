locals {
  # Feature flags
  is_enabled                = var.is_enabled
  create_domain_permissions = local.is_enabled && var.policy_document != null

  # Input validation and defaults
  effective_domain_owner = var.domain_owner != null ? var.domain_owner : data.aws_caller_identity.current.account_id
}
