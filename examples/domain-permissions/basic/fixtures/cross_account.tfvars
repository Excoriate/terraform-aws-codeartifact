# Cross Account fixture - uses a custom statement for cross-account domain access.
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace "ACCOUNT_ID_TO_GRANT_ACCESS" with the actual target account ID.

domain_name = "your-existing-domain"

# Baseline principals default to []
# read_principals                = []
# list_repo_principals           = []
# authorization_token_principals = []

custom_policy_statements = [
  {
    Sid    = "AllowCrossAccountDomainAccess",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::ACCOUNT_ID_TO_GRANT_ACCESS:root"] # Grant access to the root of another account
    },
    Action = [
      # Grant permissions appropriate for cross-account domain usage
      "codeartifact:GetDomainPermissionsPolicy",
      "codeartifact:ListRepositoriesInDomain",
      "codeartifact:GetAuthorizationToken", # Often needed for repo access
      "sts:GetServiceBearerToken"           # Required for GetAuthorizationToken
      # Add other actions like "codeartifact:CreateRepository" if needed
    ],
    Resource = "*" # Domain policy actions often use "*" resource
  }
]
