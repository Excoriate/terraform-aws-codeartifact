# This file intentionally left blank to use the default variable values
# defined in ../variables.tf for the basic example.

# You can override variables here for specific default tests, e.g.:
# external_principals = [{ account_id = "ACCOUNT_ID", role_name = "ROLE_NAME" }]
# allowed_actions = ["codeartifact:GetAuthorizationToken"]

# Default fixture for the basic example
# Demonstrates object-based trust policy (default)

is_enabled = true

domain_name      = "dpca-basic-domain-example"
role_name        = "dpca-basic-role-example"
role_description = "IAM role for cross-account CodeArtifact domain access"
role_path        = "/"

external_principals = [
  {
    account_id = "111122223333"
    role_name  = "dpca-basic-role-example"
  },
  {
    account_id = "444455556666"
    role_name  = "dpca-basic-role-example"
  }
]

# Uncomment below to use ARN-based trust policy override instead
# external_principals_arns_override = [
#   "arn:aws:iam::111122223333:role/dpca-basic-role-example",
#   "arn:aws:iam::444455556666:role/dpca-basic-role-example"
# ]

# Policy attachment
iam_role_cross_account_policies = [
  {
    name = "CodeArtifactDomainAccess"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "codeartifact:GetAuthorizationToken",
            "codeartifact:DescribeDomain",
            "codeartifact:ListRepositoriesInDomain"
          ]
          Resource = "*"
        }
      ]
    })
  }
]

tags = {
  Environment = "example"
  Project     = "domain-permissions-cross-account-basic"
  ManagedBy   = "terraform"
}
