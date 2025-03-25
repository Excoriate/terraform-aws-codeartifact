<!-- BEGIN_TF_DOCS -->
# AWS CodeArtifact Domain Permissions Module

## Overview

This Terraform module manages permissions policies for an existing AWS CodeArtifact Domain, allowing controlled access to domain resources.

### 🔑 Key Features
- **Policy Management**: Apply IAM policies to control domain access
- **Flexible Configuration**: Support for cross-account domain management
- **Controlled Access**: Fine-grained permissions management
- **Modular Design**: Can be used independently or with other CodeArtifact modules

### 📋 Usage Guidelines
1. Identify the domain you want to manage permissions for
2. Create a policy document defining the desired permissions
3. Apply this module to set the domain permissions policy

```hcl
module "codeartifact_domain_permissions" {
  source = "path/to/module"

  # Basic Configuration
  is_enabled  = true
  domain_name = "my-company-packages"

  # Define domain permissions policy
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::123456789012:role/DeveloperRole" }
        Action = [
          "codeartifact:ReadFromRepository",
          "codeartifact:DescribeRepository",
          "codeartifact:ListRepositories"
        ]
        Resource = "*"
      }
    ]
  })

  # Optional: Specify domain owner if different account
  # domain_owner = "123456789012"

  # Tagging
  tags = {
    Environment = "production"
    Project     = "package-management"
    ManagedBy   = "Terraform"
  }
}
```

## Security Considerations

- 🔒 Follow least privilege principle in domain policies
- 👥 Use targeted Principal declarations instead of wildcards
- 🔐 Limit repository creation and deletion rights
- 📝 Regularly audit domain policies

## Policy Structure Guidelines

- Define specific actions instead of using wildcards
- Explicitly list resources when possible
- Consider separating read and write permissions
- Use conditions to further restrict access based on tags, IP addresses, etc.



## Variables

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the CodeArtifact domain to add permissions to. This must reference an existing domain.<br/><br/>**IMPORTANT**: The domain must already exist. This module does not create the domain,<br/>it only adds permissions to an existing domain.<br/><br/>The domain name is used as a prefix in DNS hostnames, so it must follow DNS naming conventions:<br/>- Must be between 2-63 characters<br/>- Contain only lowercase letters, numbers, and hyphens<br/>- Cannot start or end with a hyphen | `string` | n/a | yes |
| <a name="input_policy_document"></a> [policy\_document](#input\_policy\_document) | JSON formatted IAM policy document that controls access to the domain.<br/><br/>**POLICY REQUIREMENTS**:<br/>- Must be a valid IAM policy document in JSON format<br/>- Should follow least privilege principles<br/>- Consider policies that grant specific permissions to specific principals<br/><br/>**EXAMPLE POLICY**:<pre>json<br/>{<br/>  "Version": "2012-10-17",<br/>  "Statement": [<br/>    {<br/>      "Action": [<br/>        "codeartifact:ReadFromRepository",<br/>        "codeartifact:DescribeRepository",<br/>        "codeartifact:ListRepositories"<br/>      ],<br/>      "Effect": "Allow",<br/>      "Principal": {<br/>        "AWS": "arn:aws:iam::123456789012:role/DeveloperRole"<br/>      },<br/>      "Resource": "*"<br/>    }<br/>  ]<br/>}</pre> | `string` | n/a | yes |
| <a name="input_domain_owner"></a> [domain\_owner](#input\_domain\_owner) | The AWS account ID that owns the domain. If not specified, the current account ID is used.<br/><br/>**USE CASES**:<br/>- Cross-account domain management<br/>- Multi-account architectures<br/>- Organization-wide package management<br/><br/>This parameter is particularly useful when you need to manage permissions for a domain owned by another account. | `string` | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether module resources should be created or not. This is used to enable/disable the module<br/>and all of its resources. Set to `false` to disable all resources in this module. Default is `true`.<br/><br/>**IMPORTANT**: Setting this to `false` will effectively disable the entire module and all its resources.<br/>This is useful for scenarios where you want to conditionally enable or disable a whole module. | `bool` | `true` | no |
| <a name="input_policy_revision"></a> [policy\_revision](#input\_policy\_revision) | The current revision of the resource policy to be set. This revision is used for optimistic locking,<br/>which prevents others from overwriting your changes to the domain's resource policy.<br/><br/>**USE CASES**:<br/>- When updating an existing policy<br/>- For controlled policy updates in CI/CD pipelines<br/>- When multiple systems might update policies<br/><br/>Leave as null when creating a new policy or when you don't need optimistic locking. | `string` | `null` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The name of the CodeArtifact domain. |
| <a name="output_domain_owner"></a> [domain\_owner](#output\_domain\_owner) | The AWS account ID that owns the CodeArtifact domain. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the domain-permissions module is enabled or not. |
| <a name="output_policy_document"></a> [policy\_document](#output\_policy\_document) | The JSON policy document that is set as the domain permissions policy. |
| <a name="output_policy_revision"></a> [policy\_revision](#output\_policy\_revision) | The current revision of the domain permissions policy. |
| <a name="output_resource_arn"></a> [resource\_arn](#output\_resource\_arn) | The ARN of the resource associated with the domain permissions policy. |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_domain_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy) | resource |
<!-- END_TF_DOCS -->