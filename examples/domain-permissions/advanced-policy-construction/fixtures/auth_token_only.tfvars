# This fixture tests providing only the authorization_token_principals input.
# The module should generate a policy including the default owner statement
# and the BaselineGetAuthToken statement (with sts:GetServiceBearerToken).
domain_name_suffix = "dynamic-auth"

authorization_token_principals = ["arn:aws:iam::111122223333:role/CICDRole"] # Example ARN

# Other dynamic inputs omitted
# read_principals                = []
# list_repo_principals           = []
# custom_policy_statements       = []
# policy_document_override       = null
