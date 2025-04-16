<!-- BEGIN_TF_DOCS -->
# AWS IAM Role for Cross-Account CodeArtifact Access Module

## Overview

This Terraform module creates an IAM role in the **current** (domain owner) AWS account designed to be assumed by IAM roles from **other** specified AWS accounts. It attaches IAM policies (defined by the user) to this role, granting the assumed role specific permissions, typically for accessing resources like an AWS CodeArtifact domain.

### 🔑 Key Features
- **IAM Role Creation**: Provisions an `aws_iam_role` with a configurable name, path, description, and session duration.
- **Cross-Account Trust Policy**: Automatically generates the assume role policy (trust policy) based on the list of external principals (`var.external_principals`) provided, allowing only specified roles from specified external accounts to assume this role.
- **Managed Policy Attachment**: Creates `aws_iam_policy` resources based on the JSON policy documents provided in the `var.policies` list and attaches them to the role using `aws_iam_role_policy_attachment`.
- **Exclusivity Control**: Optionally ensures that only the policies defined via `var.policies` are attached (`var.exclusive_policy_attachment`).
- **Conditional Creation**: Creates resources only if `var.is_enabled` is true.
- **Tagging**: Applies consistent tags to created resources.

### 📋 Usage Guidelines
1.  Define the IAM role details (`name`, `path`, `description`, `max_session_duration`).
2.  Specify the external principals (account IDs and role names) allowed to assume this role via `var.external_principals`.
3.  Define the permissions the cross-account role should have by providing a list of policy objects in `var.policies`. Each object needs a `name` and a `policy` (JSON string). The policy JSON should grant necessary actions (e.g., `codeartifact:GetAuthorizationToken`, `codeartifact:ReadFromRepository`) on the target resources (e.g., the CodeArtifact domain ARN).
4.  Set `var.is_enabled` to `true` (default).
5.  Apply standard tags via `var.tags`.

**Example:**
```hcl
module "codeartifact_cross_account_role" {
  source = "path/to/modules/domain-permissions-cross-account"

  is_enabled = true
  name       = "MyCodeArtifactCrossAccountReaderRole"
  path       = "/service-roles/"

  external_principals = [
    { account_id = "111122223333", role_name = "CICDDeployRole" },
    { account_id = "444455556666", role_name = "DeveloperReadOnlyRole" }
  ]

  policies = [
    {
      name   = "CodeArtifactDomainReadAccess"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "codeartifact:GetAuthorizationToken",
              "codeartifact:DescribeDomain",
              "codeartifact:ListRepositoriesInDomain"
            ],
            Resource = "arn:aws:codeartifact:us-east-1:123456789012:domain/my-central-domain" # Replace with actual domain ARN
          }
        ]
      })
    },
    {
      name   = "CodeArtifactRepoReadAccess"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "codeartifact:ReadFromRepository",
              "codeartifact:ListPackages",
              "codeartifact:DescribePackageVersion",
              "codeartifact:GetPackageVersionReadme",
              "codeartifact:GetPackageVersionAssets",
              "codeartifact:ListPackageVersions",
              "codeartifact:ListPackageVersionAssets"
            ],
            # Grant access to all repositories in the domain
            Resource = "arn:aws:codeartifact:us-east-1:123456789012:repository/my-central-domain/*" # Replace with actual domain ARN/name pattern
          }
        ]
      })
    }
  ]

  tags = {
    Environment = "shared"
    Service     = "CodeArtifact"
  }
}
```

## Security Considerations

- 🔒 Follow the principle of least privilege when defining the policy documents in `var.policies`. Grant only the necessary actions on specific resources.
- 👥 Be specific in `var.external_principals`. Avoid granting trust too broadly.
- 📝 Regularly audit the trust policy and attached permissions.



## Variables

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_principals"></a> [external\_principals](#input\_external\_principals) | List of external AWS principals (roles) allowed to assume the cross-account IAM role. Each object must specify:<br/>- `account_id`: The external AWS account ID.<br/>- `role_name`: The role name in the external account allowed to assume the role.<br/><br/>**Example:**<br/>external\_principals = [<br/>  { account\_id = "122345678901", role\_name = "test-tools-prod-ro" },<br/>  { account\_id = "122345678901", role\_name = "test-tools-dev-pu" },<br/>]<br/><br/>**References:**<br/>- [AWS IAM Role Trust Relationships](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_modify.html#roles-modify_trust-policy) | <pre>list(object({<br/>    account_id = string<br/>    role_name  = string<br/>  }))</pre> | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name for the IAM role to be created in the domain owner's account. This role will be assumed by external AWS principals.<br/><br/>**Constraints:**<br/>- Must be unique within the AWS account.<br/>- Should be descriptive of its cross-account purpose.<br/><br/>**Example:**<br/>"codeartifact-cross-account-access"<br/><br/>**References:**<br/>- [AWS IAM Role Naming](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) | `string` | n/a | yes |
| <a name="input_default_policy_desc"></a> [default\_policy\_desc](#input\_default\_policy\_desc) | Default description for policies created by this module if not specified in the `policies` variable. | `string` | `"Managed by Terraform"` | no |
| <a name="input_default_policy_path"></a> [default\_policy\_path](#input\_default\_policy\_path) | Default path for policies created by this module if not specified in the `policies` variable. Defaults to '/'. | `string` | `"/"` | no |
| <a name="input_external_principals_arns_override"></a> [external\_principals\_arns\_override](#input\_external\_principals\_arns\_override) | List of full ARNs of external AWS principals (roles) allowed to assume the cross-account IAM role.<br/>If this is set, it'll take precedence over the `external_principals` variable.<br/><br/>**Example:**<br/>external\_principals\_arns\_override = [<br/>  "arn:aws:iam::112487888422:role/dev-tools-prod-ro",<br/>  "arn:aws:iam::112487888422:role/dev-tools-dev-pu",<br/>] | `list(string)` | `[]` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Specifies whether to force detaching any policies the role has before destroying it. Defaults to false. | `bool` | `false` | no |
| <a name="input_iam_role_cross_account_policies"></a> [iam\_role\_cross\_account\_policies](#input\_iam\_role\_cross\_account\_policies) | List of IAM policies to create and attach to the cross-account role. Each object must specify:<br/>- `name`: The name of the IAM policy.<br/>- `policy`: The policy document as a JSON formatted string. Use `jsonencode()` or `file()` to provide this.<br/>- `path`: (Optional) The path for the policy. Defaults to "/".<br/>- `description`: (Optional) The description of the policy.<br/><br/>**Example:**<br/>iam\_role\_cross\_account\_policies = [<br/>  {<br/>    name   = "CodeArtifactReadOnlyAccess"<br/>    policy = jsonencode({ Version = "2012-10-17", Statement = [...] })<br/>  },<br/>  {<br/>    name   = "CodeArtifactGetToken"<br/>    policy = file("policies/get-token.json")<br/>  }<br/>] | <pre>list(object({<br/>    name        = string<br/>    path        = optional(string, "/")<br/>    description = optional(string, "Managed by Terraform")<br/>    policy      = string # Expecting JSON string content directly<br/>  }))</pre> | `[]` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether module resources should be created or not. This is used to enable/disable the module<br/>and all of its resources. Set to `false` to disable all resources in this module. Default is `true`.<br/><br/>**IMPORTANT**: Setting this to `false` will effectively disable the entire module and all its resources.<br/>This is useful for scenarios where you want to conditionally enable or disable a whole module. | `bool` | `true` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 3600 (1 hour) to 43200 (12 hours). | `number` | `3600` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the IAM role. | `string` | `"IAM role for cross-account CodeArtifact domain access"` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path for the IAM role. Defaults to '/'. | `string` | `"/"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to apply to the IAM role and policies. These tags help with resource organization, cost allocation, and compliance.<br/><br/>**Example:**<br/>{<br/>  Environment = "production"<br/>  Project     = "codeartifact-cross-account"<br/>  ManagedBy   = "Terraform"<br/>}<br/><br/>**References:**<br/>- [AWS Tagging Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html) | `map(string)` | `{}` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role_arn"></a> [cross\_account\_role\_arn](#output\_cross\_account\_role\_arn) | ARN of the cross-account IAM role that can be assumed by external principals to access the CodeArtifact domain. |
| <a name="output_cross_account_role_id"></a> [cross\_account\_role\_id](#output\_cross\_account\_role\_id) | The ID of the cross-account IAM role. |
| <a name="output_cross_account_role_name"></a> [cross\_account\_role\_name](#output\_cross\_account\_role\_name) | Name of the cross-account IAM role. |
| <a name="output_cross_account_role_unique_id"></a> [cross\_account\_role\_unique\_id](#output\_cross\_account\_role\_unique\_id) | The unique ID assigned by AWS to the cross-account IAM role. |
| <a name="output_feature_flags"></a> [feature\_flags](#output\_feature\_flags) | A map of feature flags used in the module. |
| <a name="output_module_enabled"></a> [module\_enabled](#output\_module\_enabled) | Whether the module is enabled or not. |
| <a name="output_policy_arns"></a> [policy\_arns](#output\_policy\_arns) | List of ARNs of the IAM policies created for cross-account access. |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
<!-- END_TF_DOCS -->