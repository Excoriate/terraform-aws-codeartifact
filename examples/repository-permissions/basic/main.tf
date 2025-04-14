data "aws_caller_identity" "current" {}

resource "aws_codeartifact_domain" "example" {
  count = var.is_enabled ? 1 : 0

  domain = var.domain_name
  tags   = var.tags
}

module "repository" {
  count = var.is_enabled ? 1 : 0

  source = "../../../modules/repository"

  domain_name     = aws_codeartifact_domain.example[0].domain
  repository_name = var.repository_name
  description     = "Repository created for repository-permissions basic example"
  tags            = var.tags

  depends_on = [aws_codeartifact_domain.example]
}

module "this" {
  count = var.is_enabled ? 1 : 0

  source = "../../../modules/repository-permissions"

  domain_name     = module.repository[0].repository_domain_name
  repository_name = module.repository[0].repository_name
  domain_owner    = module.repository[0].repository_domain_owner # Pass domain owner from repo module output

  # Grant read access to specified principals, or default to the current caller
  read_principals = length(var.policy_principals) > 0 ? var.policy_principals : [data.aws_caller_identity.current.arn]

  # No other baseline principals for basic example
  describe_principals            = []
  authorization_token_principals = []

  # Add a custom statement to allow the caller to publish
  custom_policy_statements = [
    {
      Sid    = "AllowCallerPublish",
      Effect = "Allow",
      Principal = {
        Type        = "AWS"
        Identifiers = [data.aws_caller_identity.current.arn]
      },
      Action = [
        "codeartifact:PublishPackageVersion",
        "codeartifact:PutPackageMetadata"
        # Add other relevant publish actions if needed, e.g.:
        # "codeartifact:AssociatePackageGroup",
        # "codeartifact:CopyPackageVersions",
        # "codeartifact:DeletePackage",
        # "codeartifact:DeletePackageVersions",
        # "codeartifact:DeleteRepository",
        # "codeartifact:DeleteRepositoryPermissionsPolicy",
        # "codeartifact:DescribePackage",
        # "codeartifact:DescribePackageVersion",
        # "codeartifact:DisposePackageVersions",
        # "codeartifact:GetPackageVersionReadme",
        # "codeartifact:ListPackageVersionAssets",
        # "codeartifact:ListPackageVersions",
        # "codeartifact:ListPackages",
        # "codeartifact:ReadFromRepository",
        # "codeartifact:UpdatePackageVersionsStatus",
        # "codeartifact:UpdateRepository"
      ],
      Resource = "*" # Resource is typically "*" in repository policies
    }
  ]

  depends_on = [module.repository]
}
