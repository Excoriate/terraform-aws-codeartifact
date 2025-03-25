locals {
  # Feature flags
  is_enabled                     = var.is_enabled
  is_permissions_policy_enabled  = var.enable_domain_permissions_policy
  create_domain                  = local.is_enabled
  create_domain_permissions_policy = local.is_enabled && local.is_permissions_policy_enabled

  # Input validation and defaults
  domain_name           = var.domain_name
  domain_owner          = var.domain_owner
  domain_permissions_policy = var.domain_permissions_policy

  # Use the caller's identity if domain_owner is not provided
  effective_domain_owner = local.domain_owner != null ? local.domain_owner : data.aws_caller_identity.current.account_id

  # Default tags to be merged with user provided tags
  default_tags = {
    "Terraform"   = "true"
    "Module"      = "terraform-aws-codeartifact-domain"
  }

  # Merged tags
  tags = merge(local.default_tags, var.tags)

  # Compute domain endpoint
  domain_endpoint = local.create_domain ? "https://${local.domain_name}-${local.effective_domain_owner}.d.codeartifact.${data.aws_region.current.name}.amazonaws.com" : null
}
