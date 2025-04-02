# Default fixture for the advanced-complete example.
# Enables the module and uses defaults defined in variables.tf
# This activates the upstream repo, downstream repo, policy, and connections.

is_enabled = true

# Use the default external_connection ("public:npmjs") defined in variables.tf
# Or uncomment below to override:
# external_connection = "public:pypi"

# All other variables use the defaults specified in variables.tf
# (e.g., domain_name, upstream_repo_name, downstream_repo_name, aws_region, tags)
# policy_principal_arn defaults to null, using the current caller identity.
