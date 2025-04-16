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

  # IAM Role configuration
  role_name        = var.role_name
  role_description = var.role_description
  role_path        = var.role_path

  # Trust policy configuration (object-based, default)
  # external_principals = var.external_principals

  # Uncomment below to use ARN-based trust policy override instead
  external_principals_arns_override = [
    "arn:aws:iam::111122223333:role/dpca-basic-role-example",
    "arn:aws:iam::444455556666:role/dpca-basic-role-example"
  ]

  external_principals = []

  iam_role_cross_account_policies = [
    {
      name = "CodeArtifactReadOnlyToken"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = ["codeartifact:GetAuthorizationToken"]
            Resource = var.is_enabled ? aws_codeartifact_domain.example[0].arn : "*"
          }
        ]
      })
    },
    {
      name = "CodeArtifactReadOnlyAccess"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "codeartifact:DescribeDomain",
              "codeartifact:ListRepositoriesInDomain"
            ]
            Resource = var.is_enabled ? aws_codeartifact_domain.example[0].arn : "*"
          }
        ]
      })
    }
  ]



  tags = var.tags

  depends_on = [aws_codeartifact_domain.example]
}
