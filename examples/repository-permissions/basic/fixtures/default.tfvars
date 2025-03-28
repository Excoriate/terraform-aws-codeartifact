# Default fixture for repository-permissions example.
# Applies a minimal policy (e.g., allowing read for the domain owner if specified, or current account).
# Replace placeholders with actual existing resource names before apply.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

# Example: Grant read access to the domain owner (or current account if domain_owner is null)
# read_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"] # This needs to be set dynamically or use a known ARN

# To make this fixture runnable for plan without extra setup,
# let's grant read access to a placeholder role ARN.
# Replace this with actual principals for apply.
read_principals = ["arn:aws:iam::123456789012:role/ExampleReaderRole"]

# Other baseline principals default to []
# custom_policy_statements defaults to []
