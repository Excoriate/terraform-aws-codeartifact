## Resource: aws\_iam\_role

Provides an IAM role.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

### [Basic Example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#basic-example)

```terraform
resource "aws_iam_role" "test_role" { name = "test_role" # Terraform's "jsonencode" function converts a # Terraform expression result to valid JSON syntax. assume_role_policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = "sts:AssumeRole" Effect = "Allow" Sid = "" Principal = { Service = "ec2.amazonaws.com" } }, ] }) tags = { tag-key = "tag-value" } }
```

### [Example of Using Data Source for Assume Role Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-of-using-data-source-for-assume-role-policy)

```terraform
data "aws_iam_policy_document" "instance_assume_role_policy" { statement { actions = ["sts:AssumeRole"] principals { type = "Service" identifiers = ["ec2.amazonaws.com"] } } } resource "aws_iam_role" "instance" { name = "instance_role" path = "/system/" assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json }
```

### [Example of Exclusive Inline Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-of-exclusive-inline-policies)

This example creates an IAM role with two inline IAM policies. If someone adds another inline policy out-of-band, on the next apply, Terraform will remove that policy. If someone deletes these policies out-of-band, Terraform will recreate them.

```terraform
resource "aws_iam_role" "example" { name = "yak_role" assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown) inline_policy { name = "my_inline_policy" policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = ["ec2:Describe*"] Effect = "Allow" Resource = "*" }, ] }) } inline_policy { name = "policy-8675309" policy = data.aws_iam_policy_document.inline_policy.json } } data "aws_iam_policy_document" "inline_policy" { statement { actions = ["ec2:DescribeAccountAttributes"] resources = ["*"] } }
```

### [Example of Removing Inline Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-of-removing-inline-policies)

This example creates an IAM role with what appears to be empty IAM `inline_policy` argument instead of using `inline_policy` as a configuration block. The result is that if someone were to add an inline policy out-of-band, on the next apply, Terraform will remove that policy.

```terraform
resource "aws_iam_role" "example" { name = "yak_role" assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown) inline_policy {} }
```

### [Example of Exclusive Managed Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-of-exclusive-managed-policies)

This example creates an IAM role and attaches two managed IAM policies. If someone attaches another managed policy out-of-band, on the next apply, Terraform will detach that policy. If someone detaches these policies out-of-band, Terraform will attach them again.

```terraform
resource "aws_iam_role" "example" { name = "yak_role" assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown) managed_policy_arns = [aws_iam_policy.policy_one.arn, aws_iam_policy.policy_two.arn] } resource "aws_iam_policy" "policy_one" { name = "policy-618033" policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = ["ec2:Describe*"] Effect = "Allow" Resource = "*" }, ] }) } resource "aws_iam_policy" "policy_two" { name = "policy-381966" policy = jsonencode({ Version = "2012-10-17" Statement = [ { Action = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"] Effect = "Allow" Resource = "*" }, ] }) }
```

### [Example of Removing Managed Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-of-removing-managed-policies)

This example creates an IAM role with an empty `managed_policy_arns` argument. If someone attaches a policy out-of-band, on the next apply, Terraform will detach that policy.

```terraform
resource "aws_iam_role" "example" { name = "yak_role" assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown) managed_policy_arns = [] }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

The following argument is required:

-   [`assume_role_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#assume_role_policy-1) - (Required) Policy that grants an entity permission to assume the role.

The following arguments are optional:

-   [`description`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#description-2) - (Optional) Description of the role.
-   [`force_detach_policies`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#force_detach_policies-1) - (Optional) Whether to force detaching any policies the role has before destroying it. Defaults to `false`.
-   [`inline_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#inline_policy-1) - (Optional, **Deprecated**) Configuration block defining an exclusive set of IAM inline policies associated with the IAM role. See below. If no blocks are configured, Terraform will not manage any inline policies in this resource. Configuring one empty block (i.e., `inline_policy {}`) will cause Terraform to remove _all_ inline policies added out of band on `apply`.
-   [`managed_policy_arns`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#managed_policy_arns-1) - (Optional, **Deprecated**) Set of exclusive IAM managed policy ARNs to attach to the IAM role. If this attribute is not configured, Terraform will ignore policy attachments to this resource. When configured, Terraform will align the role's managed policy attachments with this set by attaching or detaching managed policies. Configuring an empty set (i.e., `managed_policy_arns = []`) will cause Terraform to remove _all_ managed policy attachments.
-   [`max_session_duration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#max_session_duration-1) - (Optional) Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours.
-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-3) - (Optional, Forces new resource) Friendly name of the role. If omitted, Terraform will assign a random, unique name. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html) for more information.
-   [`name_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name_prefix-3) - (Optional, Forces new resource) Creates a unique friendly name beginning with the specified prefix. Conflicts with `name`.
-   [`path`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#path-1) - (Optional) Path to the role. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html) for more information.
-   [`permissions_boundary`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#permissions_boundary-1) - (Optional) ARN of the policy that is used to set the permissions boundary for the role.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-5) - Key-value mapping of tags for the IAM role. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

### [inline\_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#inline_policy)

This configuration block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-4) - (Required) Name of the role policy.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-4) - (Required) Policy document as a JSON formatted string. For more information about building IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy).

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn-4) - Amazon Resource Name (ARN) specifying the role.
-   [`create_date`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#create_date-1) - Creation date of the IAM role.
-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-1) - Name of the role.
-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-5) - Name of the role.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags_all-3) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).
-   [`unique_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#unique_id-1) - Stable and unique string identifying the role.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import IAM Roles using the `name`. For example:

```terraform
import { to = aws_iam_role.developer id = "developer_name" }
```

Using `terraform import`, import IAM Roles using the `name`. For example:

```console
% terraform import aws_iam_role.developer developer_name
```