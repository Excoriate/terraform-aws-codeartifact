# Read Only fixture - applies only baseline read permissions (GetDomainPermissionsPolicy).
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace principal ARN with actual principals.

domain_name = "your-existing-domain"

read_principals = ["arn:aws:iam::111122223333:role/PolicyReaderRole"]

# list_repo_principals defaults to []
# authorization_token_principals defaults to []
# custom_policy_statements defaults to []
