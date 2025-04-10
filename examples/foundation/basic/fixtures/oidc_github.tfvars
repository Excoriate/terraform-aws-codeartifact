# Fixture for enabling OIDC provider for GitHub Actions.
# Replace placeholders with your actual GitHub org/repo and desired role/policy.

is_oidc_provider_enabled = true
oidc_provider_url        = "https://token.actions.githubusercontent.com"
oidc_client_id_list      = ["sts.amazonaws.com"] # Standard for GitHub Actions

oidc_roles = [
  {
    name        = "github-oidc-foundation-example-role"
    description = "IAM role for GitHub Actions OIDC federation (Foundation Example)"
    # max_session_duration = 3600 # Optional: Defaults to 3600 in the module variable

    # --- IMPORTANT: Customize the condition ---
    # This condition allows jobs from the 'main' branch of 'your-org/your-repo' to assume the role.
    # Adjust the repo and ref according to your needs.
    # See GitHub docs for available claims: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
    condition_string_like = {
      "token.actions.githubusercontent.com:sub" = ["repo:your-org/your-repo:ref:refs/heads/main"],
      # You might also want to add an audience condition:
      # "token.actions.githubusercontent.com:aud" = ["sts.amazonaws.com"] # Usually sts.amazonaws.com
    }
    # --- End IMPORTANT ---

    # Optional: Attach policies to the role. Example uses ReadOnlyAccess.
    # Replace with ARNs of policies granting necessary permissions for your CI/CD jobs.
    attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

    # Optional: Add inline policies if needed
    # inline_policies = {
    #   "MyInlinePolicy" = jsonencode({ Version = "2012-10-17", Statement = [...] })
    # }
  }
]

# Include other required variables for the foundation module example if they differ from defaults
# codeartifact_domain_name = "your-specific-domain-for-this-test"
# kms_key_alias            = "alias/your-specific-key-alias"
# log_group_name           = "/aws/codeartifact/your-specific-logs"
# s3_bucket_name           = "your-specific-bucket-name-unique"
