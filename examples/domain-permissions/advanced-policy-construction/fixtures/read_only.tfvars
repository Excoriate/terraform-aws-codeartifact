# This fixture tests providing only the read_principals input.
# The module should generate a policy including the default owner statement
# and the BaselineReadDomainPolicy statement.
domain_name_suffix = "dynamic-read"

read_principals = ["arn:aws:iam::111122223333:role/ReadOnlyRole"] # Example ARN

# Other dynamic inputs omitted
# list_repo_principals           = []
# authorization_token_principals = []
# custom_policy_statements       = []
# policy_document_override       = null
