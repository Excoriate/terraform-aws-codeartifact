module "this" {
  source = "../../../modules/foundation"

  # Feature flags
  is_enabled           = var.is_enabled
  is_kms_key_enabled   = var.is_kms_key_enabled
  is_log_group_enabled = var.is_log_group_enabled
  is_s3_bucket_enabled = var.is_s3_bucket_enabled

  # KMS configuration
  kms_key_deletion_window = var.kms_deletion_window_in_days
  kms_key_alias           = var.kms_key_alias

  # S3 bucket configuration
  s3_bucket_name       = var.s3_bucket_name
  force_destroy_bucket = var.s3_bucket_force_destroy

  # CloudWatch Log Group configuration
  log_group_name           = var.log_group_name
  log_group_retention_days = var.log_retention_days

  # CodeArtifact domain configuration
  codeartifact_domain_name = var.codeartifact_domain_name

  tags = {
    Environment = var.environment
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
    Example     = "basic"
  }
}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}
