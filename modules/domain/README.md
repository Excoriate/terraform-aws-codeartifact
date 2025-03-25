<!-- BEGIN_TF_DOCS -->
# AWS CodeArtifact Domain Module

## Overview

This Terraform module provisions and manages an AWS CodeArtifact Domain, a fundamental organizational construct for package management across multiple software ecosystems.

### 🌐 What is an AWS CodeArtifact Domain?

An AWS CodeArtifact Domain is a high-level container that enables centralized package management across different package formats and repositories. It provides:

- **Unified Package Management**: Consolidate packages from multiple ecosystems (npm, Maven, PyPI, etc.)
- **Secure Artifact Storage**: Centralized, encrypted storage for software packages
- **Access Control**: Granular permissions management for package repositories
- **Cross-Account Sharing**: Ability to share packages across AWS accounts

### 🔑 Key Domain Characteristics

- **Unique Naming**: Each domain must have a unique name within an AWS Region and Account
- **Maximum Name Length**: 90 characters
- **Encryption**: Optional KMS encryption for domain assets
- **Multi-Repository Support**: Can contain multiple repositories
- **Global Endpoint**: Provides a unique DNS endpoint for package access

### 📦 Domain Capabilities

1. **Package Format Support**:
   - npm
   - Maven
   - PyPI
   - NuGet
   - Cargo
   - Ruby Gems
   - Swift Packages

2. **Security Features**:
   - Domain-level encryption
   - Fine-grained access policies
   - Integration with AWS IAM

3. **Operational Insights**:
   - Track repository count
   - Monitor asset size
   - Detailed creation timestamps

## Usage Example

```hcl
module "codeartifact_domain" {
  source = "path/to/module"

  # Basic Configuration
  is_enabled           = true
  domain_name          = "my-company-packages"

  # Optional Encryption
  encryption_key_arn   = aws_kms_key.domain_encryption.arn

  # Permissions Policy (Optional)
  enable_domain_permissions_policy = true
  domain_permissions_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:root" }
        Action = ["codeartifact:CreateRepository"]
        Resource = "*"
      }
    ]
  })

  # Tagging
  tags = {
    Environment = "production"
    Project     = "package-management"
    ManagedBy   = "Terraform"
  }
}
```

## Domain Endpoint Structure

The domain endpoint follows this format:
```
https://{domain-name}-{account-id}.d.codeartifact.{region}.amazonaws.com
```

## Security Considerations

- 🔒 Use KMS encryption for sensitive packages
- 👥 Implement least-privilege access policies
- 🕒 Regularly rotate authorization tokens
- 📊 Monitor domain asset sizes and repository counts

## Performance and Scaling

- Supports up to 1,000 repositories per domain
- Centralized package metadata management
- Low-latency package retrieval
- Seamless integration with package managers

## Compliance and Governance

- Audit trail for package operations
- Cross-account package sharing
- Centralized package version control
- Support for package origin restrictions

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.92.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain) | resource |
| [aws_codeartifact_domain_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the CodeArtifact domain to create. All domain names in an AWS Region that are in the same<br/>AWS account must be unique. The domain name is used as the prefix in DNS hostnames.<br/><br/>**NAMING CONSTRAINTS**:<br/>- Must be unique in your AWS account within an AWS Region<br/>- Length between 2-50 characters<br/>- Can contain lowercase letters, numbers, and hyphens<br/>- Cannot start with a hyphen<br/>- Cannot contain underscores, spaces, or any other special characters<br/><br/>**SECURITY NOTE**: Do not use sensitive information in a domain name because it is publicly discoverable. | `string` | n/a | yes |
| <a name="input_domain_owner"></a> [domain\_owner](#input\_domain\_owner) | The AWS account ID that owns the domain. Typically this is your own account ID, but this parameter<br/>allows cross-account domain configuration. If not specified, the current account ID is used.<br/><br/>**USE CASES**:<br/>- Cross-account domain sharing<br/>- Multi-account architectures<br/>- Organization-wide package management<br/><br/>This parameter is particularly useful when you want to reference a domain owned by another account. | `string` | `null` | no |
| <a name="input_domain_permissions_policy"></a> [domain\_permissions\_policy](#input\_domain\_permissions\_policy) | JSON formatted IAM policy document that controls access to the domain. This policy is applied only if<br/>`enable_domain_permissions_policy` is set to `true`.<br/><br/>**POLICY REQUIREMENTS**:<br/>- Must be a valid IAM policy document in JSON format<br/>- Should follow least privilege principles<br/>- Consider policies that grant specific permissions to specific principals<br/><br/>**EXAMPLE POLICY**:<pre>json<br/>{<br/>  "Version": "2012-10-17",<br/>  "Statement": [<br/>    {<br/>      "Action": [<br/>        "codeartifact:ReadFromRepository",<br/>        "codeartifact:DescribeRepository",<br/>        "codeartifact:ListRepositories"<br/>      ],<br/>      "Effect": "Allow",<br/>      "Principal": {<br/>        "AWS": "arn:aws:iam::123456789012:role/DeveloperRole"<br/>      },<br/>      "Resource": "*"<br/>    }<br/>  ]<br/>}</pre> | `string` | `null` | no |
| <a name="input_enable_domain_permissions_policy"></a> [enable\_domain\_permissions\_policy](#input\_enable\_domain\_permissions\_policy) | Controls whether to create a domain permissions policy. Set to `true` to create a permissions policy<br/>for the domain. Default is `false`.<br/><br/>**NOTE**: This is separate from the module-level `is_enabled` flag and allows for more granular control<br/>over which specific resources are created within the module. | `bool` | `false` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether module resources should be created or not. This is used to enable/disable the module<br/>and all of its resources. Set to `false` to disable all resources in this module. Default is `true`.<br/><br/>**IMPORTANT**: Setting this to `false` will effectively disable the entire module and all its resources.<br/>This is useful for scenarios where you want to conditionally enable or disable a whole module. | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key used to encrypt the domain's assets. This key must be created in the foundation<br/>layer and passed to this module. If not provided, AWS will use the default aws/codeartifact AWS KMS key.<br/><br/>**KEY REQUIREMENTS**:<br/>- Must be a valid KMS key ARN<br/>- Must be in the same region as the CodeArtifact domain<br/>- Must have the necessary permissions to be used by CodeArtifact<br/><br/>**SECURITY RECOMMENDATION**:<br/>It is strongly recommended to use a customer-managed KMS key for production environments<br/>to have full control over encryption and key rotation policies. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module. These tags will be applied<br/>to all resources that support tagging.<br/><br/>**TAGGING STRATEGY**:<br/>- Use consistent tag keys across your infrastructure<br/>- Consider including environment, project, owner, and cost center tags<br/>- Follow your organization's tagging standards<br/><br/>**NOTE**: Tags defined here will be merged with any default tags defined at the provider level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | The ARN of the CodeArtifact domain. |
| <a name="output_domain_asset_size_bytes"></a> [domain\_asset\_size\_bytes](#output\_domain\_asset\_size\_bytes) | The total size of all assets in the domain, in bytes. |
| <a name="output_domain_created_time"></a> [domain\_created\_time](#output\_domain\_created\_time) | The time the domain was created. |
| <a name="output_domain_encryption_key"></a> [domain\_encryption\_key](#output\_domain\_encryption\_key) | The ARN of the KMS key used to encrypt the domain's assets. |
| <a name="output_domain_endpoint"></a> [domain\_endpoint](#output\_domain\_endpoint) | The endpoint of the CodeArtifact domain |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The name of the CodeArtifact domain. |
| <a name="output_domain_owner"></a> [domain\_owner](#output\_domain\_owner) | The AWS account ID that owns the CodeArtifact domain. |
| <a name="output_domain_repository_count"></a> [domain\_repository\_count](#output\_domain\_repository\_count) | The number of repositories in the CodeArtifact domain. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the domain module is enabled or not. |
<!-- END_TF_DOCS -->
