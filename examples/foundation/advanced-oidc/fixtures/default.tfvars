# Default fixture for the Advanced OIDC example.
# This fixture enables OIDC with a basic single-role configuration.
# NOTE: KMS, S3, and Logs remain disabled by default in this OIDC-focused example
# unless explicitly enabled by overriding is_kms_key_enabled, etc.

# --- General Foundation Settings (Optional Overrides) ---
# kms_key_alias            = "alias/my-adv-default-key"
# log_group_name           = "/aws/codeartifact/my-adv-default-logs"
# s3_bucket_name           = "my-adv-default-bucket-unique-name"
# codeartifact_domain_name = "my-adv-default-domain"

# --- OIDC Provider Settings ---
is_oidc_provider_enabled = true
oidc_provider_url        = "https://gitlab.com"   # Replace with your IdP URL
oidc_client_id_list      = ["https://gitlab.com"] # Replace with your IdP client ID(s)
# oidc_use_existing_provider = false # Default

# --- OIDC Roles Definition (Basic Single Role) ---
oidc_roles = [
  {
    name        = "oidc-default-role"
    description = "Default basic OIDC role for advanced example"

    # Basic condition - REPLACE with your actual condition
    condition_string_like = {
      "gitlab.com:sub" = ["project_path:your-group/your-project:ref_type:branch:ref:main"]
    }

    # Basic policy - REPLACE with appropriate permissions
    attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
]
