# Read & Describe fixture - applies baseline read and describe permissions.
# Replace placeholders with actual existing resource names before apply.
# Replace principal ARNs with actual principals.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

read_principals = ["arn:aws:iam::111122223333:role/ReaderRole"]

describe_principals = ["arn:aws:iam::111122223333:role/CICDRole"]

# authorization_token_principals defaults to []
# custom_policy_statements defaults to []
