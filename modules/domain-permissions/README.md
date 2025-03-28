<!-- BEGIN_TF_DOCS -->
# AWS CodeArtifact Domain Permissions Module

## Overview

This Terraform module manages the resource-based permissions policy for an **existing** AWS CodeArtifact Domain. It allows controlled access to domain resources through either a dynamically constructed policy or a complete policy override.

### 🔑 Key Features
- **Policy Management**: Applies or updates the `aws_codeartifact_domain_permissions_policy` for a specified domain.
- **Dynamic Policy Construction**: Builds a policy based on lists of principals for common actions (`read_principals`, `list_repo_principals`, `authorization_token_principals`) and merges custom IAM statements (`custom_policy_statements`). Includes a default statement granting the domain owner basic read access.
- **Policy Override**: Allows providing a complete JSON policy document via `policy_document_override`, which takes precedence over dynamic construction.
- **Conditional Creation**: Creates the policy resource only if the module is enabled AND either `policy_document_override` is provided OR at least one dynamic principal/statement list is non-empty.
- **Cross-Account Support**: Handles domains owned by different AWS accounts using `domain_owner`.
- **Modular Design**: Decouples policy management from domain creation.

### 📋 Usage Guidelines
1. Ensure the target CodeArtifact domain (specified by `domain_name`) exists in the correct AWS account and region.
2. **Choose Policy Method:**
   *   **Option A (Policy Override):** Provide a complete, valid JSON policy string to `var.policy_document_override`. All other policy-related inputs (`read_principals`, `list_repo_principals`, etc.) will be ignored by the module. This is useful for complex policies or externally managed policies.
   *   **Option B (Dynamic Construction):** Leave `var.policy_document_override` as `null`. Provide principals and/or custom statements using `var.read_principals`, `var.list_repo_principals`, `var.authorization_token_principals`, and `var.custom_policy_statements`. The module will construct a policy including a default statement for the owner plus statements based on your inputs. **Note:** If all these dynamic inputs are empty/null, no policy resource will be created by default (unless `policy_document_override` is used).
3. If the domain is in another AWS account, specify its account ID in `var.domain_owner`.
4. Use `var.policy_revision` for optimistic locking if managing policy updates concurrently.
5. Set `var.is_enabled` to `false` to prevent the module from creating the policy resource.

**Example (Dynamic Construction):**
```hcl
module "codeartifact_domain_permissions" {
  source = "path/to/module"

  # Basic Configuration
  is_enabled  = true
  domain_name = "my-company-packages"

  # Baseline Permissions (Example)
  read_principals      = ["arn:aws:iam::111122223333:role/ReaderRole"]
  list_repo_principals = ["arn:aws:iam::111122223333:role/DeveloperRole"]

  # Custom Permissions (Example)
  custom_policy_statements = [
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

## Test Scenarios and Fixtures

The module includes comprehensive test scenarios to validate different configuration options:

### Fixture Types

1. **`default.tfvars`**
   - Enables the module with default configuration
   - Creates a domain with minimal baseline policy
   - Automatically adds the current account's root as a read principal

2. **`disabled.tfvars`**
   - Disables the module completely
   - Prevents creation of any domain permissions policy
   - Useful for testing conditional module creation

3. **`no-policy.tfvars`**
   - Enables the module but does not apply any policy
   - Demonstrates the module's behavior when no explicit policy inputs are provided
   - Verifies the default behavior of not creating a policy resource

4. **`cross_account.tfvars`**
   - Demonstrates cross-account domain permissions configuration
   - Allows setting custom policy statements for cross-account access
   - Useful for multi-account AWS architectures

5. **`custom-domain-owner.tfvars`**
   - Shows how to specify a custom domain owner different from the current account
   - Useful for managing domains across different AWS accounts

### Test Coverage

The module's test suite (`all_recipes_ro_test.go`) validates:
- Correct resource creation based on fixture configuration
- Policy resource presence/absence
- Default policy statement generation
- Handling of different module configuration scenarios

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
| <a name="input_authorization_token_principals"></a> [authorization\_token\_principals](#input\_authorization\_token\_principals) | (Ignored if `policy_document_override` is set)<br/>A list of IAM principal ARNs that should be granted permission to get an authorization token for the domain (`codeartifact:GetAuthorizationToken`).<br/>Also requires `sts:GetServiceBearerToken`. This is often required for principals needing to interact with repository endpoints.<br/>Example: `["arn:aws:iam::111122223333:role/CICDRole"]` | `list(string)` | `[]` | no |
| <a name="input_custom_policy_statements"></a> [custom\_policy\_statements](#input\_custom\_policy\_statements) | (Ignored if `policy_document_override` is set)<br/>A list of custom policy statement objects to be merged into the domain policy document constructed from baseline principals.<br/>Each object must follow the structure of an IAM policy statement.<br/>Required keys: `Effect` (Allow/Deny), `Action` (list of strings), `Resource` (list of strings).<br/>Optional keys: `Sid` (string), `Principal` (object with Type and Identifiers), `Condition` (object).<br/>Example granting create repository permission:<br/>[<br/>  {<br/>    Sid    = "AllowCreateRepo",<br/>    Effect = "Allow",<br/>    Principal = { Type = "AWS", Identifiers = ["arn:aws:iam::111122223333:role/AdminRole"] },<br/>    Action = ["codeartifact:CreateRepository"],<br/>    Resource = "*" # Domain policy actions often use "*" resource<br/>  }<br/>] | `list(any)` | `[]` | no |
| <a name="input_domain_owner"></a> [domain\_owner](#input\_domain\_owner) | The AWS account ID that owns the domain. If not specified, the current account ID is used.<br/><br/>**USE CASES**:<br/>- Cross-account domain management<br/>- Multi-account architectures<br/>- Organization-wide package management<br/><br/>This parameter is particularly useful when you need to manage permissions for a domain owned by another account. | `string` | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether module resources should be created or not. This is used to enable/disable the module<br/>and all of its resources. Set to `false` to disable all resources in this module. Default is `true`.<br/><br/>**IMPORTANT**: Setting this to `false` will effectively disable the entire module and all its resources.<br/>This is useful for scenarios where you want to conditionally enable or disable a whole module. | `bool` | `true` | no |
| <a name="input_list_repo_principals"></a> [list\_repo\_principals](#input\_list\_repo\_principals) | (Ignored if `policy_document_override` is set)<br/>A list of IAM principal ARNs that should be granted baseline permissions to list repositories within the domain.<br/>Action: `codeartifact:ListRepositoriesInDomain`.<br/>Example: `["arn:aws:iam::111122223333:role/DeveloperRole"]` | `list(string)` | `[]` | no |
| <a name="input_policy_document_override"></a> [policy\_document\_override](#input\_policy\_document\_override) | Optional. A complete IAM policy document string (in JSON format) to override the dynamically generated policy.<br/>If provided (not null), this document will be used directly, and the `read_principals`, `list_repo_principals`,<br/>`authorization_token_principals`, and `custom_policy_statements` variables will be ignored. | `string` | `null` | no |
| <a name="input_policy_revision"></a> [policy\_revision](#input\_policy\_revision) | The current revision of the resource policy to be set. This revision is used for optimistic locking,<br/>which prevents others from overwriting your changes to the domain's resource policy.<br/><br/>**USE CASES**:<br/>- When updating an existing policy<br/>- For controlled policy updates in CI/CD pipelines<br/>- When multiple systems might update policies<br/><br/>Leave as null when creating a new policy or when you don't need optimistic locking. | `string` | `null` | no |
| <a name="input_read_principals"></a> [read\_principals](#input\_read\_principals) | (Ignored if `policy_document_override` is set)<br/>A list of IAM principal ARNs (AWS accounts, users, or roles) that should be granted baseline read-only access to the domain policy itself.<br/>Action: `codeartifact:GetDomainPermissionsPolicy`.<br/>Example: `["arn:aws:iam::111122223333:root"]` | `list(string)` | `[]` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The name of the CodeArtifact domain the policy applies to. |
| <a name="output_domain_owner"></a> [domain\_owner](#output\_domain\_owner) | The AWS account ID that owns the CodeArtifact domain used by the policy. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Indicates whether the domain permissions policy resource was enabled and potentially created. |
| <a name="output_policy_document"></a> [policy\_document](#output\_policy\_document) | The final JSON policy document applied to the domain (either override or generated). |
| <a name="output_policy_revision"></a> [policy\_revision](#output\_policy\_revision) | The current revision of the domain permissions policy. |
| <a name="output_resource_arn"></a> [resource\_arn](#output\_resource\_arn) | The ARN of the domain permissions policy resource. |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_domain_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy) | resource |
<!-- END_TF_DOCS -->
