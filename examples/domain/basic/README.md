# Basic AWS CodeArtifact Domain Example

This example demonstrates how to use the AWS CodeArtifact domain module to create a basic domain with minimal configuration.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources anymore.

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
| is_enabled | Controls whether module resources should be created or not. | `bool` | `true` | no |
| enable_domain_permissions_policy | Controls whether to create a domain permissions policy. | `bool` | `true` | no |

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
