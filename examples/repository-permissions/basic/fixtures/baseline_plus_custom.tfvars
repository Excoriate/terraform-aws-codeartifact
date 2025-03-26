# Baseline + Custom fixture - applies baseline permissions and adds custom statements.
# Replace placeholders with actual existing resource names before apply.
# Replace principal ARNs with actual principals.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

# Baseline permissions
read_principals     = ["arn:aws:iam::111122223333:role/ReaderRole"]
describe_principals = ["arn:aws:iam::111122223333:role/CICDRole"]
# authorization_token_principals defaults to []

# Custom statement(s)
custom_policy_statements = [
  {
    Sid    = "AllowTeamBPublish",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::111122223333:role/TeamBPublisher"]
    },
    Action = [
      "codeartifact:PublishPackageVersion",
      "codeartifact:PutPackageMetadata"
    ],
    Resource = "*"
  }
]
