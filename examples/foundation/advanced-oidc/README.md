# AWS CodeArtifact Foundation Module - Advanced OIDC Example

This example demonstrates advanced usage of the OIDC features within the AWS CodeArtifact Foundation module. It focuses on creating multiple IAM roles associated with a single OIDC provider (e.g., GitLab or GitHub Actions).

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

This example includes fixtures for testing:

1.  **default.tfvars** - Default configuration with OIDC disabled.
2.  **disabled.tfvars** - Disables the entire module.
3.  **advanced-oidc.tfvars** - Enables OIDC and defines multiple roles. Customize this file with your specific provider URL, conditions, and policies.

### Using Makefile

A Makefile is provided for easier testing:

```bash
# Show all available commands
make help

# Plan commands
make plan-default         # Plan with OIDC disabled
make plan-disabled        # Plan with module entirely disabled
make plan-advanced        # Plan with advanced OIDC configuration

# Full lifecycle commands (plan, apply, destroy)
make cycle-default        # Run full cycle with OIDC disabled
make cycle-disabled       # Run full cycle with module entirely disabled
make cycle-advanced       # Run full cycle with advanced OIDC configuration

# Cleanup command
make clean                # Remove .terraform directory and Terraform state files
```

### Manual Testing

```bash
# Initialize Terraform
terraform init

# Test with advanced OIDC configuration
terraform apply -var-file=fixtures/advanced-oidc.tfvars
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
