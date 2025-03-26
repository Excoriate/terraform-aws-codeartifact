# Override fixture - provides a complete policy document, ignoring baseline/custom inputs.
# Replace "your-existing-domain" with an actual existing domain name before apply.
# Replace principal ARN with actual principals.

domain_name = "your-existing-domain"

# Baseline principals and custom statements are ignored when override is set.
# read_principals                = []
# list_repo_principals           = []
# authorization_token_principals = []
# custom_policy_statements       = []

policy_document_override = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Sid    = "AllowAdminEverythingOverride",
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::111122223333:role/DomainAdminRole" # Example Admin Role
      },
      Action   = "codeartifact:*",
      Resource = "*"
    },
    {
      # Example: Explicitly allow GetAuthorizationToken for another role via override
      Sid    = "AllowDevGetTokenOverride",
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::111122223333:role/DeveloperRole" # Example Developer Role
      },
      Action = [
        "codeartifact:GetAuthorizationToken",
        "sts:GetServiceBearerToken"
      ],
      Resource = "*"
    }
  ]
})
