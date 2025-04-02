# Default fixture for domain-permissions example.
# Applies a minimal baseline policy (e.g., allowing the domain owner to read the policy).

domain_name = "example-test-domain"

# Enable the module by default
is_enabled = true

# Example: Grant GetDomainPermissionsPolicy to the domain owner (current account)
# Using a valid ARN format that will pass validation
# read_principals = ["arn:aws:iam::123456789012:root"]

# Other baseline principals default to []
# custom_policy_statements defaults to []
