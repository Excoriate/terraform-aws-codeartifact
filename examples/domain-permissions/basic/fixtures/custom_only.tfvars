# Custom Only fixture - applies only custom statements, ignoring baseline inputs.
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace principal ARN with actual principals.

domain_name = "your-existing-domain"

# Baseline principals default to []
# read_principals                = []
# list_repo_principals           = []
# authorization_token_principals = []

# Custom statement(s)
custom_policy_statements = [
  {
    Sid    = "AllowAdminCreateAndDeleteRepo",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::111122223333:role/DomainAdminRole"]
    },
    Action = [
      "codeartifact:CreateRepository",
      "codeartifact:DeleteRepository"
      # Add any other specific admin actions needed
    ],
    Resource = "*" # Domain-level actions
  },
  {
    Sid    = "AllowSpecificCrossAccountList",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::ACCOUNT_ID_TO_GRANT_ACCESS:root"] # Replace ACCOUNT_ID
    },
    Action = [
      "codeartifact:ListRepositoriesInDomain"
    ],
    Resource = "*" # Domain-level action
  }
]
