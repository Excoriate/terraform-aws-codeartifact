# Fixture for enabling OIDC provider for GitHub Actions.
# Replace placeholders with your actual GitHub org/repo and desired role/policy.

is_oidc_provider_enabled = true
oidc_provider_url        = "https://token.actions.githubusercontent.com"
oidc_client_id_list      = ["sts.amazonaws.com"] # Standard for GitHub Actions
oidc_role_name           = "github-oidc-foundation-example-role"
oidc_role_description    = "IAM role for GitHub Actions OIDC federation (Foundation Example)"

# --- IMPORTANT: Customize the condition ---
# This condition allows jobs from the 'main' branch of 'your-org/your-repo' to assume the role.
# Adjust the repo and ref according to your needs.
# See GitHub docs for available claims: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
oidc_role_condition_string_like = {
  "token.actions.githubusercontent.com:sub" = ["repo:your-org/your-repo:ref:refs/heads/main"],
  # You might also want to add an audience condition:
  # "token.actions.githubusercontent.com:aud" = ["sts.amazonaws.com"] # Usually sts.amazonaws.com
}
# --- End IMPORTANT ---

# Optional: Attach policies to the role. Example uses ReadOnlyAccess.
# Replace with ARNs of policies granting necessary permissions for your CI/CD jobs.
oidc_role_attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

# Include other required variables for the foundation module example if they differ from defaults
# codeartifact_domain_name = "your-specific-domain-for-this-test"
