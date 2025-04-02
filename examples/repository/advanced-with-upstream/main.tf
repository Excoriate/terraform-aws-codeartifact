# This main.tf file demonstrates creating two repositories using the repository module:
# 1. An upstream repository.
# 2. A downstream repository that uses the first as an upstream and has a policy attached.
# It creates a self-contained example including the domain.

data "aws_caller_identity" "current" {}

# Create a CodeArtifact domain for the repositories
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0

  domain = var.domain_name
  tags   = var.tags
}

# Create the Upstream Repository using the module
module "repo_upstream" {
  source = "../../../modules/repository"
  count  = var.is_enabled ? 1 : 0

  is_enabled      = var.is_enabled # Pass the main toggle
  domain_name     = aws_codeartifact_domain.this[0].domain
  repository_name = var.upstream_repo_name
  description     = "Upstream repository for the example"
  tags            = var.tags

  # No upstreams or external connections for this one
  upstreams                  = null
  external_connection        = null
  repository_policy_document = null # No policy on the upstream repo in this example

  depends_on = [aws_codeartifact_domain.this]
}

# Construct the policy document for the Downstream Repository
data "aws_iam_policy_document" "repository_policy" {
  count = var.is_enabled ? 1 : 0

  statement {
    sid    = "AllowPrincipalReadDownstream"
    effect = "Allow"
    principals {
      type = "AWS"
      # Use provided principal ARN or default to the current caller
      identifiers = [coalesce(var.policy_principal_arn, data.aws_caller_identity.current.arn)]
    }
    actions = [
      "codeartifact:ReadFromRepository",
      "codeartifact:GetRepositoryEndpoint",
      "codeartifact:ListPackages",
      "codeartifact:ListPackageVersions",
      "codeartifact:DescribePackageVersion",
      "codeartifact:GetPackageVersionReadme",
      "codeartifact:GetPackageVersionAssets"
    ]
    # Construct the downstream repository ARN dynamically
    resources = [
      "arn:aws:codeartifact:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.domain_name}/${var.downstream_repo_name}"
    ]
  }

  statement {
    sid    = "AllowStsGetCallerIdentityDownstream" # Required for CodeArtifact login
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

# Create the Downstream Repository using the module
module "repo_downstream" {
  source = "../../../modules/repository"
  count  = var.is_enabled ? 1 : 0

  is_enabled      = var.is_enabled # Pass the main toggle
  domain_name     = aws_codeartifact_domain.this[0].domain
  repository_name = var.downstream_repo_name
  description     = "Downstream repository with upstream and policy"
  tags            = var.tags

  # Configure the upstream repository
  upstreams = [
    {
      repository_name = module.repo_upstream[0].repository_name
    }
  ]

  # Attach the policy document
  repository_policy_document = data.aws_iam_policy_document.repository_policy[0].json

  # No external connections for this one
  external_connection = null

  # Explicitly depend on the upstream repository module instance
  depends_on = [
    aws_codeartifact_domain.this,
    module.repo_upstream
  ]
}
