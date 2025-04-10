# Fixture for testing using an EXISTING OIDC provider.
# Assumes the provider for 'https://token.actions.githubusercontent.com' already exists in the AWS account.
# Replace placeholders if using a different provider URL or role configuration.

is_oidc_provider_enabled   = true
oidc_use_existing_provider = true                                          # Key flag for this test case
oidc_provider_url          = "https://token.actions.githubusercontent.com" # URL of the provider to look up

# Role configuration still needed, even when using an existing provider
oidc_roles = [
  {
    name        = "github-existing-oidc-basic-role"
    description = "IAM role using existing GitHub OIDC provider (Basic Example)"

    # Condition for the role
    condition_string_like = {
      "token.actions.githubusercontent.com:sub" = ["repo:your-org/your-repo:ref:refs/heads/main"]
    }

    # Attach policies
    attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
]

# Include other required variables if they differ from defaults
# codeartifact_domain_name = "your-specific-domain-for-this-test"
# kms_key_alias            = "alias/your-specific-key-alias"
# log_group_name           = "/aws/codeartifact/your-specific-logs"
# s3_bucket_name           = "your-specific-bucket-name-unique"
