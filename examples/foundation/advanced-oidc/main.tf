###################################
# Advanced OIDC Example Module Call 🚀
###################################

module "this" {
  source = "../../../modules/foundation"

  # Feature flags (can be controlled by fixtures)
  is_enabled           = var.is_enabled
  is_kms_key_enabled   = var.is_kms_key_enabled
  is_log_group_enabled = var.is_log_group_enabled
  is_s3_bucket_enabled = var.is_s3_bucket_enabled

  # KMS configuration (use specific values or pass from vars)
  kms_key_deletion_window = var.kms_deletion_window_in_days
  kms_key_alias           = var.kms_key_alias
  kms_key_policy          = var.kms_key_policy # Pass through custom policy if defined

  # S3 bucket configuration (use specific values or pass from vars)
  s3_bucket_name             = var.s3_bucket_name
  force_destroy_bucket       = var.s3_bucket_force_destroy
  s3_bucket_policy_override  = var.s3_bucket_policy_override  # Pass through override if defined
  additional_bucket_policies = var.additional_bucket_policies # Pass through additional policies if defined

  # CloudWatch Log Group configuration (use specific values or pass from vars)
  log_group_name           = var.log_group_name
  log_group_retention_days = var.log_retention_days

  # CodeArtifact domain configuration
  codeartifact_domain_name = var.codeartifact_domain_name

  # --- OIDC Provider Inputs ---
  is_oidc_provider_enabled = var.is_oidc_provider_enabled
  oidc_provider_url        = var.oidc_provider_url
  oidc_client_id_list      = var.oidc_client_id_list
  oidc_thumbprint_list     = var.oidc_thumbprint_list

  # --- OIDC Roles Input ---
  # Pass the list of role configurations defined in variables/fixtures
  oidc_roles = var.oidc_roles

  # Common Tags
  tags = {
    Environment = var.environment
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
    Example     = "advanced-oidc"
  }
}
