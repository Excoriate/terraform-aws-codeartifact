###################################
# Basic Example for AWS CodeArtifact Foundation Module
# ----------------------------------------------------
#
# This example demonstrates the basic usage of the foundation module
# which sets up the core infrastructure for AWS CodeArtifact.
#
###################################

module "this" {
  source = "../../../modules/foundation"

  # Module activation flag
  is_enabled = var.is_enabled

  # KMS Key configuration
  is_kms_key_enabled    = true
  kms_key_deletion_window = 7
  kms_key_alias         = "alias/codeartifact-encryption"

  # CloudWatch Log Group configuration
  is_log_group_enabled    = true
  log_group_name          = "/aws/codeartifact/audit-logs"
  log_group_retention_days = 30

  # S3 Bucket configuration
  is_s3_bucket_enabled  = true
  s3_bucket_name        = "codeartifact-artifacts-${random_id.this.hex}"
  force_destroy_bucket  = true

  # Tags
  tags = {
    Environment = "dev"
    Project     = "codeartifact-foundation"
    ManagedBy   = "terraform"
  }
}

# Generate a random suffix for the S3 bucket name to ensure uniqueness
resource "random_id" "this" {
  byte_length = 4
}
