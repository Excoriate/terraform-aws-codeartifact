# Cross Account Read fixture - uses a custom statement for cross-account access.
# Replace placeholders with actual existing resource names before apply.
# Replace "ACCOUNT_ID_TO_GRANT_ACCESS" with the actual target account ID.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

# Baseline principals default to []
# read_principals                = []
# describe_principals            = []
# authorization_token_principals = []

custom_policy_statements = [
  {
    Sid    = "AllowCrossAccountRead",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::ACCOUNT_ID_TO_GRANT_ACCESS:root"] # Grant access to the root of another account
    },
    Action = [
      "codeartifact:ReadFromRepository",
      "codeartifact:DescribeRepository",
      "codeartifact:ListPackages",
      "codeartifact:DescribePackageVersion",
      "codeartifact:ListPackageVersions",
      "codeartifact:GetPackageVersionReadme",
      "codeartifact:GetPackageVersionAssets",
      "codeartifact:ListPackageVersionAssets"
      # Note: GetAuthorizationToken must be granted at the DOMAIN level,
      # so it should be in the domain policy or a separate custom statement
      # targeting the domain ARN if needed by the cross-account principal.
    ],
    Resource = "*" # Resource is typically "*" in repository policies
  }
]
