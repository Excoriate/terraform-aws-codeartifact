# This fixture tests providing only the list_repo_principals input.
# The module should generate a policy including the default owner statement
# and the BaselineListRepositories statement.
domain_name_suffix = "dynamic-list"

list_repo_principals = ["arn:aws:iam::111122223333:role/RepoListerRole"] # Example ARN

# Other dynamic inputs omitted
# read_principals                = []
# authorization_token_principals = []
# custom_policy_statements       = []
# policy_document_override       = null
