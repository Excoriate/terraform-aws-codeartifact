data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_codeartifact_domain" "example" {
  count = var.is_enabled ? 1 : 0

  domain = var.domain_name
  tags   = var.tags
}

module "this" {
  source     = "../../../modules/domain-permissions-cross-account"
  is_enabled = var.is_enabled

  # Core configuration
  name        = var.role_name
  description = "Example cross-account role for CodeArtifact domain access"

  # External principals configuration
  external_principals = var.external_principals

  # IAM policy configuration
  policies = [
    {
      name = "CodeArtifactDomainAccess"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = var.allowed_actions
            Resource = var.is_enabled ? aws_codeartifact_domain.example[0].arn : "*"
          }
        ]
      })
    }
  ]

  # Standard configurations
  tags = var.tags

  depends_on = [aws_codeartifact_domain.example]
}
