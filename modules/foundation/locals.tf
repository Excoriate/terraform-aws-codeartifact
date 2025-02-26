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
  is_kms_key_enabled = var.is_enabled && var.is_kms_key_enabled
  is_log_group_enabled = var.is_enabled && var.is_log_group_enabled
  is_s3_bucket_enabled = var.is_enabled && var.is_s3_bucket_enabled

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
        Sid    = "Enable Limited IAM Root User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CodeArtifact Service Encryption Operations"
        Effect = "Allow"
        Principal = {
          Service = "codeartifact.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow S3 Service Encryption Operations"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs Encryption"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
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
