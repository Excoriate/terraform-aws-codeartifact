provider "aws" {
  region = "us-west-2"
}

locals {
  bucket_name = "codeartifact-cross-account-example"
}

module "foundation" {
  source = "../../../modules/foundation"

  is_enabled      = true
  bucket_name     = local.bucket_name
  kms_key_alias   = "alias/codeartifact-cross-account"
  log_group_name  = "/aws/codeartifact/cross-account"
  s3_bucket_name  = local.bucket_name

  # Example of adding cross-account access using additional policies
  additional_bucket_policies = [
    {
      sid     = "AllowCrossAccountAccess"
      effect  = "Allow"
      actions = ["s3:GetObject", "s3:ListBucket"]
      principals = {
        type        = "AWS"
        identifiers = ["arn:aws:iam::123456789012:root"] # Replace with actual account ID
      }
      resources = [
        "arn:aws:s3:::${local.bucket_name}",
        "arn:aws:s3:::${local.bucket_name}/*"
      ]
    },
    {
      sid     = "DenyDeleteObjects"
      effect  = "Deny"
      actions = ["s3:DeleteObject"]
      principals = {
        type        = "AWS"
        identifiers = ["arn:aws:iam::123456789012:root"] # Replace with actual account ID
      }
      resources = ["arn:aws:s3:::${local.bucket_name}/*"]
    }
  ]

  tags = {
    Environment = "development"
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
  }
}

# Example of completely overriding the bucket policy
module "foundation_override" {
  source = "../../../modules/foundation"

  is_enabled      = true
  bucket_name     = "custom-bucket-name"
  kms_key_alias   = "alias/codeartifact-custom"
  log_group_name  = "/aws/codeartifact/custom"
  s3_bucket_name  = "custom-bucket-name"

  s3_bucket_policy_override = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPartnerAccess"
        Effect = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::987654321098:root"] # Replace with partner account ID
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::custom-bucket-name",
          "arn:aws:s3:::custom-bucket-name/*"
        ]
      }
    ]
  })

  tags = {
    Environment = "development"
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
  }
}
