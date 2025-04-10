# Fixture demonstrating advanced OIDC configuration with multiple roles.
# Replace placeholders with your actual IdP URL, project paths, policies, etc.
# NOTE: This example focuses on OIDC; KMS, S3, and Logs are disabled by default
# in examples/foundation/advanced-oidc/variables.tf unless overridden here.

# --- General Foundation Settings ---
# You can override defaults here if needed, e.g., to enable other features:
# is_kms_key_enabled = true
# is_log_group_enabled = true
# is_s3_bucket_enabled = true
kms_key_alias            = "alias/adv-oidc-foundation-key"
log_group_name           = "/aws/codeartifact/adv-oidc-logs"
s3_bucket_name           = "adv-oidc-example-bucket-unique-name" # Needs to be globally unique
codeartifact_domain_name = "adv-oidc-domain"

# --- OIDC Provider Settings ---
is_oidc_provider_enabled = true
oidc_provider_url        = "https://gitlab.com"   # Replace with your IdP URL (e.g., https://token.actions.githubusercontent.com)
oidc_client_id_list      = ["https://gitlab.com"] # Replace with your IdP client ID(s) (e.g., ["sts.amazonaws.com"] for GitHub)
# oidc_thumbprint_list   = [] # Optional: Provide if auto-fetch doesn't work
# oidc_use_existing_provider = false # Default is false (create provider)

# --- OIDC Roles Definition ---
oidc_roles = [
  # Role 1: Example for Production Deployments (Tags)
  {
    name                 = "gitlab-prod-deployer-role"
    description          = "Role for production deployments from GitLab tags"
    max_session_duration = 7200 # 2 hours

    # Condition: Allow only tags starting with 'v' from a specific project
    condition_string_like = {
      # Replace 'gitlab.com:sub' with the correct claim for your IdP (e.g., 'token.actions.githubusercontent.com:sub' for GitHub)
      "gitlab.com:sub" = ["project_path:your-group/your-prod-project:ref_type:tag:ref:v*"]
    }

    # Attach managed policies (Example: PowerUser - Use least privilege in reality!)
    attach_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

    # Add inline policies (Example: Allow specific CodeArtifact actions)
    # NOTE: Provide policy as a valid JSON string, not using jsonencode()
    inline_policies = {
      "CodeArtifactProdPublish" = "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"codeartifact:PublishPackageVersion\",\n        \"sts:GetServiceBearerToken\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}"
    }
  },

  # Role 2: Example for Development Testing (Branches)
  {
    name        = "gitlab-dev-tester-role"
    description = "Role for development testing from GitLab feature branches"
    # max_session_duration defaults to 3600 (1 hour)

    # Condition: Allow only feature branches from a specific project
    condition_string_like = {
      # Replace 'gitlab.com:sub' with the correct claim for your IdP
      "gitlab.com:sub" = ["project_path:your-group/your-dev-project:ref_type:branch:ref:feature/*"]
    }

    # Attach managed policies (Example: ReadOnly)
    attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

    # No inline policies for this role in this example
    # inline_policies = {}
  }
]
