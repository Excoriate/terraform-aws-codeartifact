# This fixture tests combining multiple baseline principal inputs.
# The module should generate a policy including the default owner statement,
# the BaselineReadDomainPolicy statement, and the BaselineListRepositories statement.
domain_name_suffix = "dynamic-combo-base"

read_principals      = ["arn:aws:iam::111122223333:role/ReaderRole"]                                            # Example ARN
list_repo_principals = ["arn:aws:iam::111122223333:role/ReaderRole", "arn:aws:iam::444455556666:user/dev-user"] # Example ARNs

# Other dynamic inputs omitted
# authorization_token_principals = []
# custom_policy_statements       = []
# policy_document_override       = null
