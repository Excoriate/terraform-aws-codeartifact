provider "aws" {
  region = "us-west-2"
}

locals {
  bucket_name = "test-codeartifact-cross-account"
}

module "foundation" {
  source = "../../../../../modules/foundation"

  is_enabled      = var.is_enabled
  bucket_name     = local.bucket_name
  kms_key_alias   = "alias/test-codeartifact-cross-account"
  log_group_name  = "/aws/codeartifact/test-cross-account"
  s3_bucket_name  = local.bucket_name

  additional_bucket_policies = [
    {
      sid     = "AllowCrossAccountAccess"
      effect  = "Allow"
      actions = ["s3:GetObject", "s3:ListBucket"]
      principals = {
        type        = "AWS"
        identifiers = ["arn:aws:iam::123456789012:root"]
      }
      resources = [
        "arn:aws:s3:::${local.bucket_name}",
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
    }
  ]

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
