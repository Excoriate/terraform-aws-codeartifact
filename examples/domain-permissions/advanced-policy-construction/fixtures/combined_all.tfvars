# This fixture tests combining baseline principals and custom statements.
# The module should generate a policy including the default owner statement,
# baseline statements for read/list/auth, and the custom statement.
domain_name_suffix = "dynamic-combo-all"

read_principals                = ["arn:aws:iam::111122223333:role/ReaderRole"]
list_repo_principals           = ["arn:aws:iam::111122223333:role/DeveloperRole"]
authorization_token_principals = ["arn:aws:iam::111122223333:role/CICDRole", "arn:aws:iam::444455556666:user/dev-user"]

custom_policy_statements = [
  {
    Sid    = "AllowSpecificRepoRead"
    Effect = "Allow"
    Principal = {
      Type        = "AWS"
      Identifiers = ["arn:aws:iam::111122223333:role/LimitedReader"]
    }
    Action = [
      "codeartifact:ReadFromRepository",
      "codeartifact:GetRepositoryEndpoint"
    ]
    # Note: Domain policies often use "*" for Resource, but you *could*
    # potentially scope custom statements more tightly if needed, though
    # many domain-level actions don't support resource-specific ARNs here.
    # Check AWS docs for specific actions.
    Resource = ["*"]
  }
]

# policy_document_override is omitted (null)
