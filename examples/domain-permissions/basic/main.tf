# This main.tf file demonstrates basic usage of the domain-permissions module.
# It creates a CodeArtifact domain and applies permissions to it through the domain-permissions module.
# Input variables defined in variables.tf are passed to the module.
# Different configurations can be tested using .tfvars files in the fixtures/ directory
# (e.g., terraform plan -var-file=fixtures/read_only.tfvars)

# IMPORTANT PREREQUISITE: This example applies a policy to an *existing*
# CodeArtifact domain. Ensure the domain specified via var.domain_name
# (likely in a fixture file) exists in the target AWS account and region
# before running `terraform apply`.
# `terraform plan` can be run without the domain existing to see the generated policy.

# Get the current AWS account identity
data "aws_caller_identity" "current" {}

# Create a CodeArtifact domain for testing
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0
  domain = var.domain_name != "" ? var.domain_name : "example-domain"

  # Optional encryption configuration
  # Uncomment if you need custom encryption
  # encryption_key = aws_kms_key.example.arn

  tags = {
    Environment = "development"
    ManagedBy   = "terraform"
    Example     = "domain-permissions-basic"
  }
}

module "this" {
  # Conditionally create the module resources based on the example's is_enabled flag
  count  = var.is_enabled ? 1 : 0
  source = "../../../modules/domain-permissions"

  # Pass through variables controlled by the example/fixtures
  is_enabled                     = var.is_enabled
  domain_name                    = join("",  [for d in aws_codeartifact_domain.this: d.domain])
  domain_owner                   = var.domain_owner != "" ? var.domain_owner : data.aws_caller_identity.current.account_id
  # Use the current account ID for read_principals if none provided
  read_principals                = length(var.read_principals) > 0 ? var.read_principals : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  list_repo_principals           = var.list_repo_principals
  authorization_token_principals = var.authorization_token_principals
  custom_policy_statements       = var.custom_policy_statements
  policy_revision                = var.policy_revision
  policy_document_override       = var.policy_document_override # Pass the override variable

  depends_on = [ aws_codeartifact_domain.this ]
}
