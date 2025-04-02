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

# Construct the Assume Role Policy Document for the OIDC Role
data "aws_iam_policy_document" "oidc_assume_role" {
  # Only construct if OIDC is enabled
  count = local.is_oidc_provider_enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      # Reference the OIDC provider ARN created in main.tf
      # Using try() to avoid errors during plan if the provider resource doesn't exist yet (count=0)
      identifiers = [try(aws_iam_openid_connect_provider.oidc[0].arn, "")]
    }

    # Dynamically add condition blocks based on the input map
    dynamic "condition" {
      for_each = var.oidc_role_condition_string_like
      content {
        test     = "StringLike"
        variable = condition.key   # The key from the map, e.g., "gitlab.com:sub"
        values   = condition.value # The list of allowed patterns from the map value
      }
    }
  }
}
