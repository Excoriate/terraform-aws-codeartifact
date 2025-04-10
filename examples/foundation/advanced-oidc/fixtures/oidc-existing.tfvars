# Fixture for testing using an EXISTING OIDC provider with the Advanced OIDC example.
# Assumes the provider for 'https://gitlab.com' already exists in the AWS account.
# Replace placeholders if using a different provider URL or role configuration.
# NOTE: This example focuses on OIDC; KMS, S3, and Logs are disabled by default
# in examples/foundation/advanced-oidc/variables.tf unless overridden here.

# --- General Foundation Settings ---
# You can override defaults here if needed, e.g., to enable other features:
# is_kms_key_enabled = true
# is_log_group_enabled = true
# is_s3_bucket_enabled = true
kms_key_alias            = "alias/adv-oidc-existing-key"
log_group_name           = "/aws/codeartifact/adv-oidc-existing-logs"
s3_bucket_name           = "adv-oidc-existing-bucket-unique-name" # Needs to be globally unique
codeartifact_domain_name = "adv-oidc-existing-domain"

# --- OIDC Provider Settings ---
is_oidc_provider_enabled   = true
oidc_use_existing_provider = true                 # Key flag for this test case
oidc_provider_url          = "https://gitlab.com" # URL of the provider to look up

# --- OIDC Roles Definition ---
# Define roles to be created, which will trust the existing provider
oidc_roles = [
  {
    name        = "gitlab-existing-oidc-adv-role"
    description = "IAM role using existing GitLab OIDC provider (Advanced Example)"

    # Condition for the role
    condition_string_like = {
      "gitlab.com:sub" = ["project_path:your-group/your-repo:ref_type:branch:ref:main"]
    }

    # Attach policies
    attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
]
