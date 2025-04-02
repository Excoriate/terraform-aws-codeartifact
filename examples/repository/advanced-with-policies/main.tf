# This main.tf file demonstrates attaching a policy to a CodeArtifact repository
# using the repository module's `repository_policy_document` input.
# It creates a self-contained example including the domain and policy document.

data "aws_caller_identity" "current" {}

# Create a CodeArtifact domain for the repository
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0

  domain = var.domain_name
  tags   = var.tags
  # KMS key creation is disabled by default in variables.tf for simplicity
}

# Construct the repository policy document
data "aws_iam_policy_document" "repository_policy" {
  count = var.is_enabled && var.create_policy ? 1 : 0

  statement {
    sid    = "AllowPrincipalRead"
    effect = "Allow"
    principals {
      type = "AWS"
      # Use provided principal ARN or default to the current caller
      identifiers = [coalesce(var.policy_principal_arn, data.aws_caller_identity.current.arn)]
    }
    actions = [
      "codeartifact:ReadFromRepository",
      "codeartifact:GetRepositoryEndpoint", # Often needed with read access
      "codeartifact:ListPackages",
      "codeartifact:ListPackageVersions",
      "codeartifact:DescribePackageVersion",
      "codeartifact:GetPackageVersionReadme",
      "codeartifact:GetPackageVersionAssets"
    ]
    # Construct the repository ARN dynamically
    resources = [
      "arn:aws:codeartifact:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.domain_name}/${var.repository_name}"
    ]
  }

  statement {
    sid    = "AllowStsGetCallerIdentity" # Required for CodeArtifact login
    effect = "Allow"
    principals {
      type = "AWS"
      # Use provided principal ARN or default to the current caller
      identifiers = [coalesce(var.policy_principal_arn, data.aws_caller_identity.current.arn)]
    }
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"] # sts:GetCallerIdentity does not support resource-level permissions
  }
}

# Call the repository module
module "this" {
  source = "../../../modules/repository"

  # Required inputs
  is_enabled = var.is_enabled
  # Ensure the module depends on the domain being created first
  domain_name     = var.is_enabled ? aws_codeartifact_domain.this[0].domain : var.domain_name
  repository_name = var.repository_name

  # Optional features
  description = var.description

  # Pass the constructed policy document if policy creation is enabled
  repository_policy_document = var.is_enabled && var.create_policy ? data.aws_iam_policy_document.repository_policy[0].json : null

  # Keep other optional features disabled for this policy-focused example
  upstreams           = null
  external_connection = null # Controlled by var.enable_npm_external_connection which defaults to false

  # Tags
  tags = var.tags

  depends_on = [aws_codeartifact_domain.this]
}
