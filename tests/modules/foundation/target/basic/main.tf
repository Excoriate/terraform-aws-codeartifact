###################################
# Target Test Configuration for AWS CodeArtifact Foundation Module
# ----------------------------------------------------
#
# This configuration is used for unit testing the foundation module
# through the features_test.go test file.
#
###################################

module "foundation" {
  source = "../../../../../modules/foundation"

  # Module activation flag
  is_enabled = var.is_enabled

  # KMS Key configuration
  is_kms_key_enabled        = var.is_kms_key_enabled
  kms_key_deletion_window   = var.kms_key_deletion_window
  kms_key_enable_key_rotation = var.kms_key_enable_key_rotation
  kms_key_alias             = var.kms_key_alias

  # CloudWatch Log Group configuration
  is_log_group_enabled      = var.is_log_group_enabled
  log_group_name            = var.log_group_name
  log_group_retention_days  = var.log_group_retention_days

  # S3 Bucket configuration
  is_s3_bucket_enabled      = var.is_s3_bucket_enabled
  s3_bucket_name            = var.s3_bucket_name
  force_destroy_bucket      = var.force_destroy_bucket
  s3_bucket_versioning      = var.s3_bucket_versioning

  # Tags
  tags = var.tags
}
