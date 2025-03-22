# AWS CodeArtifact Foundation Module - Basic Example

This is a basic example of how to use the AWS CodeArtifact Foundation module. The foundation module creates the infrastructure required for CodeArtifact, including:

- KMS encryption key for CodeArtifact artifacts
- S3 bucket for backups and artifact migrations
- CloudWatch Log Group for audit logs

## Usage

```hcl
module "codeartifact_foundation" {
  source = "github.com/example-org/terraform-aws-codeartifact//modules/foundation"

  is_enabled = true

  # KMS configuration
  kms_key_deletion_window = 7
  kms_key_alias           = "alias/codeartifact-encryption"

  # S3 bucket configuration
  s3_bucket_name       = "codeartifact-artifacts-example"
  force_destroy_bucket = true

  # CloudWatch Log Group configuration
  log_group_name           = "/aws/codeartifact/audit-logs"
  log_group_retention_days = 30

  tags = {
    Environment = "dev"
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
  }
}
```

## Feature Flags

This module supports the following feature flags:

- `is_enabled` - Master toggle for all resources in this module
- `is_kms_key_enabled` - Flag to control KMS key creation
- `is_log_group_enabled` - Flag to control CloudWatch Log Group creation
- `is_s3_bucket_enabled` - Flag to control S3 bucket creation

By default, all features are enabled when `is_enabled = true`. You can disable specific features by setting their corresponding flags to `false`.

## Testing with Fixtures

This example includes several fixtures for testing different configurations:

1. **default.tfvars** - Enables all module components
2. **disabled.tfvars** - Disables the entire module
3. **kms-disabled.tfvars** - Disables only the KMS key component
4. **s3-disabled.tfvars** - Disables only the S3 bucket component
5. **logs-disabled.tfvars** - Disables only the CloudWatch Logs component

These fixtures demonstrate the module's flexibility, allowing you to selectively enable or disable components as needed for your specific use case.

### Using Makefile

A Makefile is provided for easier testing. Here are some of the available commands:

```bash
# Show all available commands
make help

# Plan commands
make plan-default         # Plan with all components enabled
make plan-disabled        # Plan with module entirely disabled
make plan-kms-disabled    # Plan with KMS key component disabled
make plan-s3-disabled     # Plan with S3 bucket component disabled
make plan-logs-disabled   # Plan with CloudWatch logs component disabled

# Full lifecycle commands (plan, apply, destroy)
make cycle-default        # Run full cycle with all components enabled
make cycle-disabled       # Run full cycle with module entirely disabled
make cycle-kms-disabled   # Run full cycle with KMS key component disabled
make cycle-s3-disabled    # Run full cycle with S3 bucket component disabled
make cycle-logs-disabled  # Run full cycle with CloudWatch logs component disabled

# Cleanup command
make clean                # Remove .terraform directory and Terraform state files
```

### Manual Testing

If you prefer to run Terraform commands directly:

```bash
# Initialize Terraform
terraform init

# Test with all components enabled
terraform apply -var-file=fixtures/default.tfvars

# Test with entire module disabled
terraform apply -var-file=fixtures/disabled.tfvars

# Test with specific components disabled
terraform apply -var-file=fixtures/kms-disabled.tfvars
terraform apply -var-file=fixtures/s3-disabled.tfvars
terraform apply -var-file=fixtures/logs-disabled.tfvars
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
