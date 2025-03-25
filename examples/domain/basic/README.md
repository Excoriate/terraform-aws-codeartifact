# AWS CodeArtifact Domain - Basic Example

This example demonstrates how to use the AWS CodeArtifact Domain module to create and manage a CodeArtifact domain with various configurations.

## Usage

```hcl
module "codeartifact_domain" {
  source = "terraform-aws-modules/codeartifact/aws//modules/domain"

  is_enabled  = true
  domain_name = "my-domain"
  kms_key_arn = aws_kms_key.domain_encryption.arn

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
    Environment = "development"
    Project     = "my-project"
  }
}
```

## Features Demonstrated in Fixtures

This example includes multiple fixtures to demonstrate different domain configurations:

| Fixture | Description | Use Case |
|---------|-------------|----------|
| `default.tfvars` | Default configuration with all features enabled | Simple domain creation with custom KMS key |
| `disabled.tfvars` | Module entirely disabled | No resources created (for testing/staging) |
| `with-domain-permissions.tfvars` | Domain with permissions policy | Setting domain-level access controls |
| `custom-domain-owner.tfvars` | Domain with custom owner account | Cross-account domain sharing |
| `no-encryption.tfvars` | Domain using default AWS encryption | Simpler setup without custom KMS |
| `combined-features.tfvars` | Multiple features enabled simultaneously | Comprehensive domain configuration |

## Testing Different Configurations

Use the included Makefile to test different configurations:

```bash
# Initialize Terraform
make init

# Test default configuration
make plan-default
make apply-default
make destroy-default

# Test with domain permissions policy
make plan-with-domain-permissions
make apply-with-domain-permissions
make destroy-with-domain-permissions

# Full test cycle with all features
make cycle-combined-features
```

## Notes

- The KMS key in this example is created for demonstration purposes. In a real environment, you might want to use a key from your foundation module.
- The domain owner in the cross-account example uses a placeholder account ID.
- This is a basic example to demonstrate the functionality of the domain module. For more complex configurations, see the complete example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| this | ../../../modules/domain | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_domain\_permissions\_policy | Controls whether to create a domain permissions policy. | `bool` | `true` | no |
| is\_enabled | Controls whether module resources should be created or not. | `bool` | `true` | no |
| domain\_owner | The AWS account ID that owns the domain. If not specified, the current account ID is used. | `string` | `null` | no |
| use\_default\_kms | Whether to use the default AWS KMS key instead of creating a custom key. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| is\_enabled | Whether the module is enabled or not. |
| domain\_arn | ARN of the CodeArtifact domain. |
| domain\_name | Name of the CodeArtifact domain. |
| domain\_owner | AWS account ID that owns the domain. |
| domain\_encryptionkey | KMS encryption key ARN for CodeArtifact domain. |
| domain\_repository\_count | Number of repositories in the domain. |
| domain\_asset\_size | Storage size in bytes used by the domain. |
| domain\_created\_time | Time the domain was created. |
| domain\_endpoint | The endpoint of the CodeArtifact domain. |
| domain\_policy\_document | The domain permissions policy document applied to the domain. |
| domain\_policy\_revision | The current revision of the domain permissions policy. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
