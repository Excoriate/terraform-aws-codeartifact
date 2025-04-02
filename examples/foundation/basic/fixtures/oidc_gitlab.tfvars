# Fixture for enabling OIDC provider for GitLab.com
# Replace placeholders with your actual GitLab project path and desired role/policy.

is_oidc_provider_enabled = true
oidc_provider_url        = "https://gitlab.com"
oidc_client_id_list      = ["https://gitlab.com"] # Common for GitLab.com
oidc_role_name           = "gitlab-oidc-foundation-example-role"
oidc_role_description    = "IAM role for GitLab OIDC federation (Foundation Example)"

# --- IMPORTANT: Customize the condition ---
# This condition allows jobs from the 'main' branch of 'your-group/your-project' to assume the role.
# Adjust the project_path, ref_type, and ref according to your needs.
# See GitLab docs for available claims: https://docs.gitlab.com/ee/ci/cloud_services/aws/
oidc_role_condition_string_like = {
  "gitlab.com:sub" = ["project_path:your-group/your-project:ref_type:branch:ref:main"]
}
# --- End IMPORTANT ---

# Optional: Attach policies to the role. Example uses ReadOnlyAccess.
# Replace with ARNs of policies granting necessary permissions for your CI/CD jobs.
oidc_role_attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

# Include other required variables for the foundation module example if they differ from defaults
# codeartifact_domain_name = "your-specific-domain-for-this-test"
