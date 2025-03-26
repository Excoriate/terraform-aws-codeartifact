# Custom Only fixture - applies only custom statements, ignoring baseline inputs.
# Replace placeholders with actual existing resource names before apply.
# Replace principal ARN with actual principals.

domain_name     = "your-existing-domain"
repository_name = "your-existing-repo"

# Baseline principals default to []
# read_principals                = []
# describe_principals            = []
# authorization_token_principals = []

# Custom statement(s)
custom_policy_statements = [
  {
    Sid    = "AllowSpecificAdmin",
    Effect = "Allow",
    Principal = {
      Type        = "AWS",
      Identifiers = ["arn:aws:iam::111122223333:role/RepoAdminRole"]
    },
    Action = [
      "codeartifact:*" # Example: Grant full admin access via custom statement
    ],
    Resource = "*"
  },
  {
    Sid    = "DenyDeleteForEveryoneElse", # Example deny statement
    Effect = "Deny",
    Principal = "*",
    Action = [
      "codeartifact:DeleteRepository",
      "codeartifact:DeletePackage",
      "codeartifact:DeletePackageVersion"
    ],
    Resource = "*",
    Condition = {
      StringNotEquals = {
        "aws:PrincipalArn" = "arn:aws:iam::111122223333:role/RepoAdminRole"
      }
    }
  }
]
