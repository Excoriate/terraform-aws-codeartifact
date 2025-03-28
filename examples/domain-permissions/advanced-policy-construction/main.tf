# This main.tf file demonstrates dynamic policy construction using the domain-permissions module.
# It creates a temporary CodeArtifact domain and then calls the module to apply permissions.
# Input variables defined in variables.tf are passed to the module, often controlled by fixtures.

# Get the current AWS account identity for default owner calculation
data "aws_caller_identity" "current" {}

# Create a temporary CodeArtifact domain for this example run
resource "aws_codeartifact_domain" "this" {
  count  = var.is_enabled ? 1 : 0
  domain = "example-domain-${var.domain_name_suffix}" # Use suffix for uniqueness

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Example     = "domain-permissions-dynamic"
    Temporary   = "true" # Indicate it's for testing
  }
}

# Call the domain-permissions module
module "this" {
  # Conditionally create the module resources based on the example's is_enabled flag
  count  = var.is_enabled ? 1 : 0
  source = "../../../modules/domain-permissions"

  # --- Module Inputs ---
  is_enabled = var.is_enabled # Pass the example's flag

  # Required: Link to the domain created above
  domain_name = aws_codeartifact_domain.this[0].domain

  # Optional: Use explicit owner from var or default to current account
  domain_owner = coalesce(var.domain_owner, data.aws_caller_identity.current.account_id)

  # Pass through dynamic policy variables (controlled by fixtures)
  read_principals                = var.read_principals
  list_repo_principals           = var.list_repo_principals
  authorization_token_principals = var.authorization_token_principals
  custom_policy_statements       = var.custom_policy_statements

  # Pass through other optional variables
  policy_revision          = var.policy_revision
  policy_document_override = var.policy_document_override

  # Ensure the domain exists before trying to apply policy
  depends_on = [aws_codeartifact_domain.this]
}
