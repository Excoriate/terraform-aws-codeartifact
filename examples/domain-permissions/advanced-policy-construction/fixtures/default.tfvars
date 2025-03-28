# This fixture tests the default behavior when no dynamic policy inputs are provided.
# The domain-permissions module should NOT create a policy resource in this case
# (though it generates a default policy internally if it were to create one).
# is_enabled defaults to true in variables.tf
domain_name_suffix = "dynamic-default"

# All dynamic inputs are omitted, relying on their defaults (empty lists or null)
# read_principals                = []
# list_repo_principals           = []
# authorization_token_principals = []
# custom_policy_statements       = []
# policy_document_override       = null
