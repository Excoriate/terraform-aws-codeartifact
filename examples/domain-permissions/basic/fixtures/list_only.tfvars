# List Only fixture - applies only baseline list repositories permissions.
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace principal ARN with actual principals.

domain_name = "your-existing-domain"

list_repo_principals = ["arn:aws:iam::111122223333:role/DeveloperRole"]

# read_principals defaults to []
# authorization_token_principals defaults to []
# custom_policy_statements defaults to []
