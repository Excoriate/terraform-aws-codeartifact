# Read Only fixture - applies only baseline read permissions.
# Replace placeholders with actual existing resource names before apply.
# Replace principal ARN with actual principals.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

read_principals = ["arn:aws:iam::111122223333:role/ReadOnlyRole"]

# describe_principals defaults to []
# authorization_token_principals defaults to []
# custom_policy_statements defaults to []
