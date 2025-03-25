locals {
  region      = "us-west-2"
  environment = "test"
  name        = "example"
}

################################################################################
# Domain (Required for domain-permissions)
################################################################################

resource "aws_kms_key" "this" {
  count = var.is_enabled ? 1 : 0

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

# Create a domain that we'll use to set permissions on
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0

  domain         = "${local.name}-domain"
  encryption_key = aws_kms_key.this[0].arn

  tags = {
    Name        = "${local.name}-domain"
    Environment = local.environment
  }
}

################################################################################
# Domain Permissions Module
################################################################################

module "this" {
  source = "../../../modules/domain-permissions"

  is_enabled   = var.is_enabled
  domain_name  = var.is_enabled ? aws_codeartifact_domain.this[0].domain : "non-existent-domain"
  domain_owner = var.domain_owner

  # The policy document is built based on the example variable value
  policy_document = var.is_enabled && var.policy_type != "none" ? (
    var.policy_type == "read_only" ? jsonencode({
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
            AWS = var.principal_arn != null ? var.principal_arn : data.aws_caller_identity.current.account_id
          }
          Resource = "*"
        }
      ]
      }) : var.policy_type == "admin" ? jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "codeartifact:*"
          ]
          Effect = "Allow"
          Principal = {
            AWS = var.principal_arn != null ? var.principal_arn : data.aws_caller_identity.current.account_id
          }
          Resource = "*"
        }
      ]
      }) : jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "codeartifact:ReadFromRepository",
            "codeartifact:DescribeRepository"
          ]
          Effect = "Allow"
          Principal = {
            AWS = var.principal_arn != null ? var.principal_arn : data.aws_caller_identity.current.account_id
          }
          Resource = "*"
        }
      ]
    })
  ) : null

  policy_revision = var.policy_revision
}

################################################################################
# Supporting Resources
################################################################################

data "aws_caller_identity" "current" {}
