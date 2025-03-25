locals {
  region      = "us-west-2"
  environment = "test"
  name        = "example"
}

################################################################################
# KMS Key (normally from foundation module)
################################################################################

resource "aws_kms_key" "this" {
  count = var.is_enabled && !var.use_default_kms ? 1 : 0

  description             = "KMS key for CodeArtifact domain encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
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
      },
      {
        Sid    = "Allow CodeArtifact to use the key"
        Effect = "Allow"
        Principal = {
          Service = "codeartifact.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${local.name}-kms-key"
    Environment = local.environment
  }
}

################################################################################
# CodeArtifact Domain Module
################################################################################

module "this" {
  source = "../../../modules/domain"

  is_enabled   = var.is_enabled
  domain_name  = "${local.name}-domain"
  kms_key_arn  = var.use_default_kms ? null : try(aws_kms_key.this[0].arn, null)
  domain_owner = var.domain_owner

  # Optional: Enable domain permissions policy
  enable_domain_permissions_policy = var.enable_domain_permissions_policy
  domain_permissions_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:DescribeRepository",
          "codeartifact:ListRepositories"
        ]
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = local.environment
    Terraform   = "true"
    Example     = "basic"
  }
}

################################################################################
# Supporting Resources
################################################################################

data "aws_caller_identity" "current" {}
