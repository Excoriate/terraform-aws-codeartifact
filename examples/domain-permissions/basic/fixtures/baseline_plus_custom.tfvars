# Baseline + Custom fixture - applies baseline permissions and adds custom statements.
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace principal ARNs with actual principals.

domain_name = "your-existing-domain"

# Baseline permissions
list_repo_principals           = ["arn:aws:iam::111122223333:role/DeveloperRole"]
authorization_token_principals = ["arn:aws:iam::111122223333:role/DeveloperRole", "arn:aws:iam::111122223333:role/CICDRole"]
# read_principals defaults to []

# Custom statement(s)
custom_policy_statements = [
  {
    Sid    = "AllowAdminCreateRepo",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::111122223333:role/AdminRole"]
    },
    Action = [
      "codeartifact:CreateRepository"
    ],
    Resource = "*" # CreateRepository is a domain-level action
  }
]
