###################################
# Module Resources 🛠️
# ----------------------------------------------------
#
# This section declares the resources that will be created or managed by this Terraform module.
# Each resource is annotated with comments explaining its purpose and any notable configurations.
#
###################################

###################################
# KMS Key for Encryption 🔐
# ----------------------------------------------------
#
# KMS key used for encrypting CodeArtifact artifacts
# and S3 bucket objects
#
###################################
resource "aws_kms_key" "this" {
  count = local.is_kms_key_enabled ? 1 : 0

  description             = local.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  policy                  = local.kms_key_policy

  tags = merge(
    local.common_tags,
    {
      Name = "codeartifact-encryption-key"
    }
  )
}

resource "aws_kms_alias" "this" {
  count = local.is_kms_key_enabled ? 1 : 0

  name          = var.kms_key_alias
  target_key_id = aws_kms_key.this[0].key_id
}

###################################
# CloudWatch Log Group 📝
# ----------------------------------------------------
#
# Log group for CodeArtifact audit logs
#
###################################
resource "aws_cloudwatch_log_group" "this" {
  count = local.is_log_group_enabled ? 1 : 0

  name              = var.log_group_name
  retention_in_days = var.log_group_retention_days
  kms_key_id       = local.is_kms_key_enabled ? aws_kms_key.this[0].arn : null

  tags = merge(
    local.common_tags,
    {
      Name = var.log_group_name
    }
  )
}

###################################
# S3 Bucket for Backup/Migration 🪣
# ----------------------------------------------------
#
# S3 bucket for storing CodeArtifact backups and
# migration artifacts
#
###################################
resource "aws_s3_bucket" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket        = var.s3_bucket_name
  force_destroy = var.force_destroy_bucket

  tags = merge(
    local.common_tags,
    {
      Name = var.s3_bucket_name
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.is_kms_key_enabled ? aws_kms_key.this[0].arn : null
      sse_algorithm     = local.is_kms_key_enabled ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count = local.is_bucket_policy_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = local.bucket_policy
}
