# AWS CodeArtifact Foundation Module - Advanced OIDC Example

**Focus:** This example demonstrates advanced usage of the OIDC features within the AWS CodeArtifact Foundation module. It focuses *only* on creating the OIDC provider and multiple associated IAM roles. Other foundation components (KMS Key, S3 Bucket, CloudWatch Log Group) are **disabled by default** in this example's variable definitions (`variables.tf`) to keep the focus narrow.

## Usage

This example showcases how to define multiple roles using the `oidc_roles` input variable, each with potentially different conditions, managed policies, and inline policies.

Refer to the `fixtures/advanced-oidc.tfvars` file for a detailed example configuration demonstrating multiple roles.

```hcl
# Example snippet from main.tf
module "this" {
  source = "../../../modules/foundation"

  # Enable OIDC
  is_oidc_provider_enabled = var.is_oidc_provider_enabled
  oidc_provider_url        = var.oidc_provider_url
  oidc_client_id_list      = var.oidc_client_id_list
  oidc_thumbprint_list     = var.oidc_thumbprint_list

  # Define multiple roles
  oidc_roles = var.oidc_roles

  # Other foundation module inputs (KMS, S3, Logs)...
  kms_key_alias            = var.kms_key_alias
  log_group_name           = var.log_group_name
  s3_bucket_name           = var.s3_bucket_name
  codeartifact_domain_name = var.codeartifact_domain_name
  # ... other variables ...

  tags = {
    Environment = var.environment
    Project     = "terraform-aws-codeartifact"
    ManagedBy   = "terraform"
    Example     = "advanced-oidc"
  }
}
```

## Testing with Fixtures

This example includes fixtures for testing various OIDC scenarios:

1.  **default.tfvars** - Default configuration (OIDC disabled, other components disabled by default). Results in no resources created.
2.  **disabled.tfvars** - Disables the entire module (`is_enabled = false`). Results in no resources created.
3.  **advanced-oidc.tfvars** - Enables OIDC provider creation and defines multiple roles. Customize this file with your specific provider URL, conditions, and policies. Only OIDC resources will be created unless you override `is_kms_key_enabled`, etc.
4.  **oidc-existing.tfvars** - Enables OIDC but uses an existing provider (looked up by URL) and defines roles to trust it. Only OIDC roles will be created unless you override other feature flags.

### Using Makefile

A Makefile is provided for easier testing:

```bash
# Show all available commands
make help

# Plan commands
make plan-default         # Plan with OIDC disabled (and others disabled by default)
make plan-disabled        # Plan with module entirely disabled
make plan-advanced        # Plan creating OIDC provider and multiple roles
make plan-oidc-existing   # Plan using existing OIDC provider and creating roles

# Full lifecycle commands (plan, apply, destroy)
make cycle-default        # Run full cycle with OIDC disabled (and others disabled by default)
make cycle-disabled       # Run full cycle with module entirely disabled
make cycle-advanced       # Run full cycle creating OIDC provider and multiple roles
make cycle-oidc-existing  # Run full cycle using existing OIDC provider and creating roles

# Cleanup command
make clean                # Remove .terraform directory and Terraform state files
```

### Manual Testing

```bash
# Initialize Terraform
terraform init

# Test creating provider and roles
terraform apply -var-file=fixtures/advanced-oidc.tfvars

# Test using existing provider and creating roles
terraform apply -var-file=fixtures/oidc-existing.tfvars
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
