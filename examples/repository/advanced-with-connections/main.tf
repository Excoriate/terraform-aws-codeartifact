# This main.tf file demonstrates creating a repository with external connections
# using the repository module's `external_connections` input.
# It creates a self-contained example including the domain.

# Create a CodeArtifact domain for the repository
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0

  domain = var.domain_name
  tags   = var.tags
}

# Call the repository module
module "this" {
  source = "../../../modules/repository"
  count  = var.is_enabled ? 1 : 0

  # Required inputs
  is_enabled      = var.is_enabled # Pass the main toggle
  domain_name     = aws_codeartifact_domain.this[0].domain
  repository_name = var.repository_name

  # Configure the single external connection using the variable
  external_connection = var.external_connection

  # Leave other optional features as default (null) for this example
  description                = "Repository example with external connections"
  upstreams                  = null
  repository_policy_document = null

  # Tags
  tags = var.tags

  depends_on = [aws_codeartifact_domain.this]
}
