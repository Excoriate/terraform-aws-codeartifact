Attaches a Managed IAM Policy to an IAM role

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
data "aws_iam_policy_document" "assume_role" { statement { effect = "Allow" principals { type = "Service" identifiers = ["ec2.amazonaws.com"] } actions = ["sts:AssumeRole"] } } resource "aws_iam_role" "role" { name = "test-role" assume_role_policy = data.aws_iam_policy_document.assume_role.json } data "aws_iam_policy_document" "policy" { statement { effect = "Allow" actions = ["ec2:Describe*"] resources = ["*"] } } resource "aws_iam_policy" "policy" { name = "test-policy" description = "A test policy" policy = data.aws_iam_policy_document.policy.json } resource "aws_iam_role_policy_attachment" "test-attach" { role = aws_iam_role.role.name policy_arn = aws_iam_policy.policy.arn }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`role`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#role-3) (Required) - The name of the IAM role to which the policy should be applied
-   [`policy_arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy_arn-2) (Required) - The ARN of the policy you want to apply

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports no additional attributes.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import IAM role policy attachments using the role name and policy arn separated by `/`. For example:

```terraform
import { to = aws_iam_role_policy_attachment.test-attach id = "test-role/arn:aws:iam::xxxxxxxxxxxx:policy/test-policy" }
```

Using `terraform import`, import IAM role policy attachments using the role name and policy arn separated by `/`. For example:

```console
% terraform import aws_iam_role_policy_attachment.test-attach test-role/arn:aws:iam::xxxxxxxxxxxx:policy/test-policy
```
