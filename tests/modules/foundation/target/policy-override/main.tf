provider "aws" {
  region = "us-west-2"
}

locals {
  bucket_name = "test-codeartifact-policy-override"
}

module "foundation" {
  source = "../../../../../modules/foundation"

  is_enabled      = var.is_enabled
  bucket_name     = local.bucket_name
  kms_key_alias   = "alias/test-codeartifact-policy-override"
  log_group_name  = "/aws/codeartifact/test-policy-override"
  s3_bucket_name  = local.bucket_name

  s3_bucket_policy_override = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCustomAccess"
        Effect = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::987654321098:root"]
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })

  tags = {
    Environment = "test"
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
  }
}

variable "is_enabled" {
  type    = bool
  default = true
}

output "bucket_name" {
  value = module.foundation.bucket_name
}

output "bucket_arn" {
  value = module.foundation.bucket_arn
}
