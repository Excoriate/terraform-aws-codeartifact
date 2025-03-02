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

This example includes two fixtures for testing:

1. **default.tfvars** - Enables the module with default settings
2. **disabled.tfvars** - Disables the module completely

### Using Makefile

A Makefile is provided for easier testing. You can use the following commands:

```bash
# Show available commands
make help

# Plan with module enabled
make plan-default

# Plan with module disabled
make plan-disabled

# Full cycle (plan, apply, destroy) with module enabled
make cycle-default

# Full cycle (plan, apply, destroy) with module disabled
make cycle-disabled

# Clean up Terraform files
make clean
```

### Manual Testing

If you prefer to run Terraform commands directly:

```bash
# Test with default configuration
terraform apply -var-file=fixtures/default.tfvars

# Test with module disabled
terraform apply -var-file=fixtures/disabled.tfvars
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
