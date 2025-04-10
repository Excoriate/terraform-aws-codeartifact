###################################
# Data Sources 📊
# ----------------------------------------------------
#
# Data sources required by this module
#
###################################

data "aws_caller_identity" "current" {}

###################################
# OIDC Data Sources 🔑
# ----------------------------------------------------
#
# Data sources for OIDC provider configuration
#
###################################

# Fetch TLS certificate thumbprint if not provided explicitly
# Requires the 'tls' provider, ensure it's added to versions.tf if not already present
data "tls_certificate" "oidc" {
  # Only run if OIDC is enabled AND thumbprints are not manually provided
  count = local.is_oidc_provider_enabled && length(var.oidc_thumbprint_list) == 0 ? 1 : 0

  url = var.oidc_provider_url
}

# Data source to look up an existing OIDC provider if requested
data "aws_iam_openid_connect_provider" "existing" {
  # Only run if OIDC is enabled AND we are told to use an existing provider
  count = local.is_oidc_provider_enabled && var.oidc_use_existing_provider ? 1 : 0

  url = var.oidc_provider_url
}

# Construct the Assume Role Policy Document for each OIDC Role
data "aws_iam_policy_document" "oidc_assume_role" {
  # Create one policy document per role defined in var.oidc_roles, only if OIDC is enabled
  for_each = local.is_oidc_provider_enabled ? { for role in var.oidc_roles : role.name => role } : {}

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      # Reference the OIDC provider ARN (either created or existing) via the local variable
      # Ensure the local variable is not null before proceeding. This check might be better placed
      # where the data source is consumed, but adding a basic check here.
      identifiers = [local.oidc_provider_arn]
    }

    # Dynamically add condition blocks based on the input map for the specific role
    # Note: This data source now depends on local.oidc_provider_arn which depends on the provider resource/data source.
    dynamic "condition" {
      # Iterate over the condition_string_like map for the current role (each.value)
      for_each = each.value.condition_string_like
      content {
        test     = "StringLike"
        variable = condition.key   # The key from the role's condition map, e.g., "gitlab.com:sub"
        values   = condition.value # The list of allowed patterns from the role's condition map value
      }
    }
  }
}
