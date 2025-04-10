# Fixture for enabling OIDC provider for GitLab.com
# Replace placeholders with your actual GitLab project path and desired role/policy.

is_oidc_provider_enabled = true
oidc_provider_url        = "https://gitlab.com"
oidc_client_id_list      = ["https://gitlab.com"] # Common for GitLab.com

oidc_roles = [
  {
    name        = "gitlab-oidc-foundation-example-role"
    description = "IAM role for GitLab OIDC federation (Foundation Example)"
    # max_session_duration = 3600 # Optional: Defaults to 3600 in the module variable

    # --- IMPORTANT: Customize the condition ---
    # This condition allows jobs from the 'main' branch of 'your-group/your-project' to assume the role.
    # Adjust the project_path, ref_type, and ref according to your needs.
    # See GitLab docs for available claims: https://docs.gitlab.com/ee/ci/cloud_services/aws/
    condition_string_like = {
      "gitlab.com:sub" = ["project_path:your-group/your-project:ref_type:branch:ref:main"]
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
