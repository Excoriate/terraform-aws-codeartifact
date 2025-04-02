# This main.tf file demonstrates usage of the domain-permissions module
# specifically focusing on the policy_document_override feature.
# It creates a CodeArtifact domain and applies a completely custom policy to it.

# Get the current AWS account identity
data "aws_caller_identity" "current" {}

# Create a CodeArtifact domain for testing this example
# Note: The domain name used here should match the one used in the override policy JSON
resource "aws_codeartifact_domain" "this" {
  count  = var.is_enabled ? 1 : 0
  domain = var.domain_name # Provided by fixture

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Example     = "advanced-policy-override"
  }
}

# Define the override policy document using a data source
data "aws_iam_policy_document" "override_policy" {
  count = var.is_enabled ? 1 : 0 # Only generate if enabled

  statement {
    sid    = "OverrideMainAllowOwnerListRepos"
    effect = "Allow"
    principals {
      type = "AWS"
      # Use the current account executing Terraform
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "codeartifact:ListRepositoriesInDomain",
      "codeartifact:GetDomainPermissionsPolicy"
    ]
    # For the example, use a hardcoded ARN format instead of the actual domain ARN
    # This breaks the dependency cycle
    resources = var.is_enabled ? [
      "arn:aws:codeartifact:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}"
    ] : []
  }
}

# Create a local variable to hold the policy JSON to avoid dependency cycles
locals {
  policy_document_override = var.is_enabled && length(data.aws_iam_policy_document.override_policy) > 0 ? data.aws_iam_policy_document.override_policy[0].json : null
}

# Call the domain-permissions module
module "this" {
  # Conditionally create the module resources based on the example's is_enabled flag
  count  = var.is_enabled ? 1 : 0
  source = "../../../modules/domain-permissions"

  # Core inputs for the module
  is_enabled   = var.is_enabled
  domain_name  = var.domain_name
  domain_owner = var.domain_owner != null ? var.domain_owner : data.aws_caller_identity.current.account_id

  # --- Policy Override ---
  # Provide the override policy document directly from the local variable
  policy_document_override = local.policy_document_override

  # Ensure dynamic policy inputs are explicitly null/empty so the override is guaranteed to be used
  read_principals                = null
  list_repo_principals           = null
  authorization_token_principals = null
  custom_policy_statements       = null

  # Optional policy revision
  policy_revision = var.policy_revision

  depends_on = [aws_codeartifact_domain.this]
}
