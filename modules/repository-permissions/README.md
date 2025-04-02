<!-- BEGIN_TF_DOCS -->
# Terraform Module: AWS CodeArtifact Repository Permissions

## Overview
> **Note:** This module manages the resource policy for an **existing** AWS CodeArtifact repository. It allows defining baseline permissions for common access patterns (read, describe, auth token) and merging additional custom policy statements.

### 🔑 Key Features
- Applies `aws_codeartifact_repository_permissions_policy` to a specified repository.
- Constructs policy dynamically based on baseline principal lists (`read_principals`, `describe_principals`, `authorization_token_principals`).
- Allows merging custom IAM policy statements (`custom_policy_statements`).
- Supports cross-account scenarios via `domain_owner`.
- Conditional creation via `is_enabled` flag.

### 📋 Usage Guidelines
1. Ensure the target CodeArtifact domain and repository already exist.
2. Provide the `domain_name` and `repository_name`.
3. Define principals for baseline access using `read_principals`, `describe_principals`, and/or `authorization_token_principals`.
4. Optionally, provide specific IAM policy statement objects via `custom_policy_statements` for more granular control.
5. If the domain is in another account, specify `domain_owner`.
6. Use `policy_revision` for optimistic locking if managing an existing policy.

```hcl
module "repo_policy" {
  source = "../path/to/repository-permissions"

  is_enabled      = true
  domain_name     = "my-existing-domain"
  repository_name = "my-existing-repo"

  # Baseline permissions
  read_principals     = ["arn:aws:iam::111122223333:role/ReaderRole"]
  describe_principals = ["arn:aws:iam::111122223333:role/CICDRole"]
  authorization_token_principals = ["arn:aws:iam::111122223333:role/DeveloperRole"]

  # Custom statement
  custom_policy_statements = [
    {
      Sid    = "AllowTeamAPublish",
      Effect = "Allow",
      Principal = { Type = "AWS", Identifiers = ["arn:aws:iam::111122223333:role/TeamAPublisher"] },
      Action = [
        "codeartifact:PublishPackageVersion",
        "codeartifact:PutPackageMetadata"
        # Add other publish-related actions as needed
        ],
      Resource = "*" # Resource is typically "*" in repository policies
    }
  ]
}
```



## Variables

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_token_principals"></a> [authorization\_token\_principals](#input\_authorization\_token\_principals) | A list of IAM principal ARNs that should be granted permission to get an authorization token for the domain (`codeartifact:GetAuthorizationToken`).<br/>This is often required for principals (especially cross-account) needing to interact with the repository endpoint using package managers.<br/>Example: `["arn:aws:iam::111122223333:role/DeveloperRole"]` | `list(string)` | `[]` | no |
| <a name="input_custom_policy_statements"></a> [custom\_policy\_statements](#input\_custom\_policy\_statements) | A list of custom policy statement objects to be merged into the repository policy document.<br/>Each object must follow the structure of an IAM policy statement.<br/>Required keys: `Effect` (Allow/Deny), `Action` (list of strings), `Resource` (list of strings).<br/>Optional keys: `Sid` (string), `Principal` (object with Type and Identifiers), `Condition` (object).<br/>Example:<br/>[<br/>  {<br/>    Sid    = "AllowSpecificPublish",<br/>    Effect = "Allow",<br/>    Principal = { Type = "AWS", Identifiers = ["arn:aws:iam::111122223333:role/PublisherRole"] },<br/>    Action = ["codeartifact:PublishPackageVersion"],<br/>    Resource = ["*"] # Typically "*" for repository policies, but can be more specific if needed<br/>  }<br/>] | `list(any)` | `[]` | no |
| <a name="input_describe_principals"></a> [describe\_principals](#input\_describe\_principals) | A list of IAM principal ARNs that should be granted baseline permissions to describe/list repositories and packages.<br/>Actions typically include: `codeartifact:DescribeRepository`, `codeartifact:ListPackages`, `codeartifact:DescribePackageVersion`.<br/>Example: `["arn:aws:iam::111122223333:role/CICD"]` | `list(string)` | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the CodeArtifact domain containing the repository. This domain must exist. | `string` | n/a | yes |
| <a name="input_domain_owner"></a> [domain\_owner](#input\_domain\_owner) | The AWS account ID that owns the domain. If not specified, the AWS account ID of the caller is used.<br/>Required if the domain is owned by a different account than the one applying this policy. | `string` | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether the CodeArtifact repository permissions policy is created or managed by this module.<br/>Set to `false` to disable the resource creation/management. | `bool` | `true` | no |
| <a name="input_policy_revision"></a> [policy\_revision](#input\_policy\_revision) | The current revision of the resource policy to be set. This revision is used for optimistic locking,<br/>which prevents others from overwriting your changes to the repository's resource policy.<br/>Leave as null when creating a new policy or when optimistic locking is not needed. | `string` | `null` | no |
| <a name="input_read_principals"></a> [read\_principals](#input\_read\_principals) | A list of IAM principal ARNs (AWS accounts, users, or roles) that should be granted baseline read-only access to the repository.<br/>Actions typically include: `codeartifact:ReadFromRepository`, `codeartifact:GetPackageVersionReadme`, `codeartifact:GetPackageVersionAssets`, `codeartifact:ListPackageVersions`, `codeartifact:ListPackageVersionAssets`.<br/>Example: `["arn:aws:iam::111122223333:root", "arn:aws:iam::444455556666:role/ReadOnlyRole"]` | `list(string)` | `[]` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the CodeArtifact repository to apply the permissions policy to. This repository must exist within the specified domain. | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The name of the CodeArtifact domain. |
| <a name="output_domain_owner"></a> [domain\_owner](#output\_domain\_owner) | The AWS account ID that owns the CodeArtifact domain. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Indicates whether the repository permissions policy resource was enabled and potentially created. |
| <a name="output_policy_document"></a> [policy\_document](#output\_policy\_document) | The generated JSON policy document applied to the repository. |
| <a name="output_policy_revision"></a> [policy\_revision](#output\_policy\_revision) | The current revision of the repository permissions policy. Useful for optimistic locking. |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | The name of the CodeArtifact repository. |
| <a name="output_resource_arn"></a> [resource\_arn](#output\_resource\_arn) | The ARN of the repository permissions policy resource. |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_codeartifact_repository_permissions_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository_permissions_policy) | resource |
<!-- END_TF_DOCS -->