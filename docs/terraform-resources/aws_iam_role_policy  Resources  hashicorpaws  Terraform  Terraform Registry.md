## Resource: aws\_iam\_role\_policy

Provides an IAM role inline policy.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
resource "aws_iam_role_policy" "test_policy" { name = "test_policy" role = aws_iam_role.test_role.id # Terraform's "jsonencode" function converts a # Terraform expression result to valid JSON syntax. policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = [ "ec2:Describe*", ] Effect = "Allow" Resource = "*" }, ] }) } resource "aws_iam_role" "test_role" { name = "test_role" assume_role_policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = "sts:AssumeRole" Effect = "Allow" Sid = "" Principal = { Service = "ec2.amazonaws.com" } }, ] }) }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-9) - (Optional) The name of the role policy. If omitted, Terraform will assign a random, unique name.
-   [`name_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name_prefix-5) - (Optional) Creates a unique name beginning with the specified prefix. Conflicts with `name`.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-6) - (Required) The inline policy document. This is a JSON formatted string. For more information about building IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy)
-   [`role`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#role-1) - (Required) The name of the IAM role to attach to the policy.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-4) - The role policy ID, in the form of `role_name:role_policy_name`.
-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-10) - The name of the policy.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-7) - The policy document attached to the role.
-   [`role`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#role-2) - The name of the role associated with the policy.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import IAM Role Policies using the `role_name:role_policy_name`. For example:

```terraform
import { to = aws_iam_role_policy.mypolicy id = "role_of_mypolicy_name:mypolicy_name" }
```

Using `terraform import`, import IAM Role Policies using the `role_name:role_policy_name`. For example:

```console
% terraform import aws_iam_role_policy.mypolicy role_of_mypolicy_name:mypolicy_name
```
