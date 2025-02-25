Attaches a Managed IAM Policy to user(s), role(s), and/or group(s)

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
resource "aws_iam_user" "user" { name = "test-user" } data "aws_iam_policy_document" "assume_role" { statement { effect = "Allow" principals { type = "Service" identifiers = ["ec2.amazonaws.com"] } actions = ["sts:AssumeRole"] } } resource "aws_iam_role" "role" { name = "test-role" assume_role_policy = data.aws_iam_policy_document.assume_role.json } resource "aws_iam_group" "group" { name = "test-group" } data "aws_iam_policy_document" "policy" { statement { effect = "Allow" actions = ["ec2:Describe*"] resources = ["*"] } } resource "aws_iam_policy" "policy" { name = "test-policy" description = "A test policy" policy = data.aws_iam_policy_document.policy.json } resource "aws_iam_policy_attachment" "test-attach" { name = "test-attachment" users = [aws_iam_user.user.name] roles = [aws_iam_role.role.name] groups = [aws_iam_group.group.name] policy_arn = aws_iam_policy.policy.arn }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-7) (Required) - Name of the attachment. This cannot be an empty string.
-   [`users`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#users-1) (Optional) - User(s) the policy should be applied to.
-   [`roles`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#roles-1) (Optional) - Role(s) the policy should be applied to.
-   [`groups`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#groups-1) (Optional) - Group(s) the policy should be applied to.
-   [`policy_arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy_arn-1) (Required) - ARN of the policy you want to apply. Typically this should be a reference to the ARN of another resource to ensure dependency ordering, such as `aws_iam_policy.example.arn`.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-3) - Policy's ID.
-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-8) - Name of the attachment.
