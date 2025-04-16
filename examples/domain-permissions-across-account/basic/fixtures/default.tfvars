# This file intentionally left blank to use the default variable values
# defined in ../variables.tf for the basic example.

# You can override variables here for specific default tests, e.g.:
# external_principals = [{ account_id = "ACCOUNT_ID", role_name = "ROLE_NAME" }]
# allowed_actions = ["codeartifact:GetAuthorizationToken"]

# Default fixture for the basic example
# This file demonstrates how to override default values in variables.tf

# These values match the defaults in variables.tf, but are shown here as examples
# of how to override them if needed

# role_name = "dpca-basic-role-example"

# external_principals = [
#   {
#     account_id = "111122223333"
#     role_name  = "dpca-basic-role-example"
#   },
#   {
#     account_id = "444455556666"
#     role_name  = "dpca-basic-role-example"
#   }
# ]

# allowed_actions = [
#   "codeartifact:GetAuthorizationToken",
#   "codeartifact:DescribeDomain",
#   "codeartifact:ListRepositoriesInDomain"
# ]
