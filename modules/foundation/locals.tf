locals {
  ###################################
  # Feature Flags ⛳️
  # ----------------------------------------------------
  #
  # These flags are used to enable or disable certain features.
  # 1. `is_enabled` - Master toggle for all resources in this module
  # 2. `is_kms_key_enabled` - Flag to control KMS key creation
  # 3. `is_log_group_enabled` - Flag to control CloudWatch Log Group creation
  # 4. `is_s3_bucket_enabled` - Flag to control S3 bucket creation
  #
  ###################################
  is_enabled = var.is_enabled
  is_kms_key_enabled = var.is_enabled
  is_log_group_enabled = var.is_enabled
  is_s3_bucket_enabled = var.is_enabled

  ###################################
  # Resource Naming 🏷️
  # ----------------------------------------------------
  #
  # Standardized naming for resources created by this module
  #
  ###################################
  kms_key_description = "KMS key for CodeArtifact encryption and backup"
  kms_key_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  ###################################
  # Tags 🏷️
  # ----------------------------------------------------
  #
  # Common tags to be applied to all resources
  #
  ###################################
  common_tags = merge(
    var.tags,
    {
      "Module"     = "terraform-aws-codeartifact-foundation"
      "ManagedBy"  = "terraform"
    }
  )
}
