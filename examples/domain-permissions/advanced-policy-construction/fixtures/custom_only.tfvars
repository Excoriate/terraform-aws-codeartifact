# This fixture tests providing only custom_policy_statements.
# The module should generate a policy including the default owner statement
# and the provided custom statement(s).
domain_name_suffix = "dynamic-custom"

custom_policy_statements = [
  {
    Sid    = "AllowRepoCreationForAdmin"
    Effect = "Allow"
    Principal = {
      Type        = "AWS"
      Identifiers = ["arn:aws:iam::111122223333:role/AdminRole"] # Example ARN
    }
    Action = [
      "codeartifact:CreateRepository"
    ]
    Resource = ["*"] # CreateRepository often requires "*" in domain policy
  }
]

# Other dynamic inputs omitted
# read_principals                = []
# list_repo_principals           = []
# authorization_token_principals = []
# policy_document_override       = null
