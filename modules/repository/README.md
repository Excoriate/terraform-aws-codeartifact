<!-- BEGIN_TF_DOCS -->
# Terraform Module: AWS CodeArtifact Repository

## Overview
> **Note:** This module provides resources for creating and managing an AWS CodeArtifact repository, including optional upstream configurations, external connections, and repository policies.

### 🔑 Key Features
- Creates a CodeArtifact repository within a specified domain.
- Supports **hosted** repositories (no upstreams/connections) for internal package storage.
- Supports **proxy** repositories via internal `upstreams` to other domain repositories.
- Supports **proxy** repositories via public `external_connections` (e.g., to npmjs, PyPI).
- Supports **combined** proxy repositories (internal upstreams + external connections).
- Supports attaching an optional repository permissions policy (`repository_policy_document`).
- Conditional creation via `is_enabled` flag.
- Standardized tagging (`tags`).

### 📋 Usage Guidelines
1. Ensure the specified CodeArtifact domain (`var.domain_name`) exists.
2. Provide a unique `var.repository_name`.
3. Optionally configure `var.upstreams` for proxy behavior.
4. Optionally configure `var.external_connections` to link to public repositories.
5. Optionally provide a JSON policy document via `var.repository_policy_document`.
6. Apply standard tags via `var.tags`.



## Variables

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description for the CodeArtifact repository.<br/>If not provided (`null`), no description will be set. | `string` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the CodeArtifact domain where the repository will be created.<br/>This domain must already exist. | `string` | n/a | yes |
| <a name="input_external_connection"></a> [external\_connection](#input\_external\_connection) | An optional external connection for the repository.<br/>Valid values are strings representing predefined external connection names (e.g., "public:npmjs", "public:pypi", "public:maven-central").<br/>This allows the repository to fetch packages from public repositories. Only one connection is allowed per repository.<br/>If `null`, no external connection will be configured.<br/>Refer to AWS CodeArtifact documentation for available external connection names. | `string` | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether the CodeArtifact repository and related resources are created.<br/>Set to `false` to disable the module entirely. | `bool` | `true` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the CodeArtifact repository to create.<br/>Repository names must be unique within a domain. | `string` | n/a | yes |
| <a name="input_repository_policy_document"></a> [repository\_policy\_document](#input\_repository\_policy\_document) | An optional JSON policy document to attach to the repository as a resource policy.<br/>This controls permissions for accessing the repository.<br/>If `null`, no repository policy will be created by this module. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the CodeArtifact repository resource.<br/>These tags will be merged with any default tags defined in the module.<br/>Example: `{ Environment = "production", Project = "my-app" }` | `map(string)` | `{}` | no |
| <a name="input_upstreams"></a> [upstreams](#input\_upstreams) | An optional list of upstream repositories for this repository.<br/>Each upstream object must contain the `repository_name` of an existing repository within the same domain.<br/>This is typically used for creating proxy repositories.<br/>Example: `[{ repository_name = "upstream-repo-1" }, { repository_name = "upstream-repo-2" }]`<br/>If `null`, no upstream repositories will be configured. | <pre>list(object({<br/>    repository_name = string<br/>  }))</pre> | `null` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the repository is enabled. |
| <a name="output_policy_revision"></a> [policy\_revision](#output\_policy\_revision) | The revision of the repository permissions policy. Only set if a policy is created. |
| <a name="output_repository_administrator_account"></a> [repository\_administrator\_account](#output\_repository\_administrator\_account) | The AWS account ID that owns the repository. |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | The ARN of the created CodeArtifact repository. |
| <a name="output_repository_domain_owner"></a> [repository\_domain\_owner](#output\_repository\_domain\_owner) | The AWS account ID that owns the domain. |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | The name of the created CodeArtifact repository. |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository) | resource |
| [aws_codeartifact_repository_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository_permissions_policy) | resource |
<!-- END_TF_DOCS -->