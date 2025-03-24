# AWS CodeArtifact Domain Terraform Module

This module manages an AWS CodeArtifact domain, which is the highest-level entity in CodeArtifact. A domain contains a collection of package repositories that can share package assets with each other based on domain-level permissions.

## Features

- Creates a CodeArtifact domain with encryption using KMS
- Optionally applies domain permissions policies
- Supports cross-account domain configuration
- Implements feature flags for conditionally creating resources

## Usage

```hcl
provider "aws" {
  region = "us-west-2"
}

module "codeartifact_domain" {
  source = "github.com/example-org/terraform-aws-codeartifact//modules/domain"

  domain_name = "example-domain"
  kms_key_arn = "arn:aws:kms:us-west-2:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  
  # Optional: Enable domain permissions policy
  enable_domain_permissions_policy = true
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
          AWS = "arn:aws:iam::123456789012:role/DeveloperRole"
        }
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "Production"
    Terraform   = "true"
    Project     = "MyProject"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain) | resource |
| [aws_codeartifact_domain_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| is_enabled | Controls whether module resources should be created or not. | `bool` | `true` | no |
| domain_name | The name of the CodeArtifact domain to create. | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS key used to encrypt the domain's assets. | `string` | `null` | no |
| domain_owner | The AWS account ID that owns the domain. | `string` | `null` | no |
| enable_domain_permissions_policy | Controls whether to create a domain permissions policy. | `bool` | `false` | no |
| domain_permissions_policy | JSON formatted IAM policy document that controls access to the domain. | `string` | `null` | no |
| tags | A map of tags to assign to all resources created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_arn | The ARN of the CodeArtifact domain. |
| domain_name | The name of the CodeArtifact domain. |
| domain_owner | The AWS account ID that owns the CodeArtifact domain. |
| domain_repository_count | The number of repositories in the CodeArtifact domain. |
| domain_encryption_key | The ARN of the KMS key used to encrypt the domain's assets. |
| domain_created_time | The time the domain was created. |
| domain_asset_size_bytes | The total size of all assets in the domain, in bytes. |
| domain_endpoint | The endpoint of the domain. |
| is_enabled | Whether the domain module is enabled or not. | 
