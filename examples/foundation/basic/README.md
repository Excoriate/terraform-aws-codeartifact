# Basic AWS CodeArtifact Foundation Example

This example demonstrates the basic usage of the AWS CodeArtifact Foundation module, which sets up the core infrastructure required for AWS CodeArtifact.

## Features Demonstrated

This example showcases:

- Creating a KMS key for encryption
- Setting up a CloudWatch Log Group for audit logs
- Provisioning an S3 bucket for artifacts and backups
- Applying proper tagging to all resources

## Usage

To run this example, execute:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

To clean up the resources created by this example, run:

```bash
terraform destroy
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.10.0 |
| aws | >= 4.0.0 |
| random | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| random | >= 3.0.0 |

## Resources Created

This example creates the following resources:

- KMS Key and Alias for encryption
- CloudWatch Log Group for audit logs
- S3 Bucket with versioning and encryption enabled
- Random ID for unique S3 bucket naming

## Inputs

No inputs are required for this basic example as all values are hardcoded in the configuration files.

## Outputs

| Name | Description |
|------|-------------|
| is_enabled | Whether the module is enabled |
| kms_key_arn | The ARN of the KMS key used for encryption |
| kms_key_id | The ID of the KMS key used for encryption |
| kms_key_alias_name | The name of the KMS key alias |
| log_group_arn | The ARN of the CloudWatch Log Group |
| log_group_name | The name of the CloudWatch Log Group |
| s3_bucket_id | The name of the S3 bucket |
| s3_bucket_arn | The ARN of the S3 bucket |
| s3_bucket_domain_name | The domain name of the S3 bucket | 

<!-- BEGIN_TF_DOCS -->
# Basic AWS CodeArtifact Foundation Example

## Overview
> **Note:** This example demonstrates the basic usage of the AWS CodeArtifact Foundation module, which sets up the core infrastructure required for AWS CodeArtifact.

### 🔑 Key Features
- **KMS Encryption**: Creates a KMS key for encrypting CodeArtifact resources
- **Audit Logging**: Sets up a CloudWatch Log Group for audit logs
- **Artifact Storage**: Provisions an S3 bucket for artifacts and backups
- **Security Best Practices**: Implements proper encryption and access controls

### 📋 Usage Guidelines
1. Initialize the Terraform configuration with `terraform init`
2. Validate the configuration with `terraform validate`
3. Review the planned changes with `terraform plan`
4. Apply the configuration with `terraform apply`
5. Clean up resources with `terraform destroy` when no longer needed



## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |

## Resources

## Resources

| Name | Type |
|------|------|
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

## Inputs

No inputs.

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled |
| <a name="output_kms_key_alias_name"></a> [kms\_key\_alias\_name](#output\_kms\_key\_alias\_name) | The name of the KMS key alias |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ID of the KMS key used for encryption |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch Log Group |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch Log Group |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The domain name of the S3 bucket |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the S3 bucket |
<!-- END_TF_DOCS -->