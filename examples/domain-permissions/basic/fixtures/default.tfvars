# Default fixture for domain-permissions example.
# Applies a minimal baseline policy (e.g., allowing the domain owner to read the policy).
# Replace "your-existing-domain" with an actual existing domain name before apply.

domain_name = "your-existing-domain"

# Example: Grant GetDomainPermissionsPolicy to the domain owner (current account if domain_owner is null)
# This requires using a data source in the fixture or hardcoding an ARN.
# For simplicity in plan, let's use a placeholder ARN. Replace for apply.
read_principals = ["arn:aws:iam::123456789012:root"] # Placeholder for domain owner/current account

# Other baseline principals default to []
# custom_policy_statements defaults to []
