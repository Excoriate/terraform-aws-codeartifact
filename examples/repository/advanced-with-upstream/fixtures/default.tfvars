# Default fixture for the advanced-with-upstream example.
# Enables the module and uses defaults defined in variables.tf

is_enabled = true

# All other variables use the defaults specified in variables.tf
# (e.g., domain_name, upstream_repo_name, downstream_repo_name, aws_region, tags)
# policy_principal_arn defaults to null, using the current caller identity.
