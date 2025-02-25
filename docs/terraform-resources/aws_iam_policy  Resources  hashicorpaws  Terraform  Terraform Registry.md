## Resource: aws\_iam\_policy

Provides an IAM policy.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
resource "aws_iam_policy" "policy" { name = "test_policy" path = "/" description = "My test policy" # Terraform's "jsonencode" function converts a # Terraform expression result to valid JSON syntax. policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = [ "ec2:Describe*", ] Effect = "Allow" Resource = "*" }, ] }) }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`description`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#description-3) - (Optional, Forces new resource) Description of the IAM policy.
-   [`name_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name_prefix-4) - (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with `name`.
-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-6) - (Optional, Forces new resource) Name of the policy. If omitted, Terraform will assign a random, unique name.
-   [`path`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#path-2) - (Optional, default "/") Path in which to create the policy. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html) for more information.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-5) - (Required) Policy document. This is a JSON formatted string. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy)
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-6) - (Optional) Map of resource tags for the IAM Policy. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn-5) - ARN assigned by AWS to this policy.
-   [`attachment_count`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attachment_count-1) - Number of entities (users, groups, and roles) that the policy is attached to.
-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-2) - ARN assigned by AWS to this policy.
-   [`policy_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy_id-1) - Policy's ID.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags_all-4) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import IAM Policies using the `arn`. For example:

```terraform
import { to = aws_iam_policy.administrator id = "arn:aws:iam::123456789012:policy/UsersManageOwnCredentials" }
```

Using `terraform import`, import IAM Policies using the `arn`. For example:

```console
% terraform import aws_iam_policy.administrator arn:aws:iam::123456789012:policy/UsersManageOwnCredentials
```
