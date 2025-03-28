Generates an IAM policy document in JSON format for use with resources that expect policy documents such as [`aws_iam_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy).

Using this data source to generate policy documents is _optional_. It is also valid to use literal JSON strings in your configuration or to use the `file` interpolation function to read a raw JSON policy document from a file.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-usage)

### [Basic Example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#basic-example)

```terraform
data "aws_iam_policy_document" "example" { statement { sid = "1" actions = [ "s3:ListAllMyBuckets", "s3:GetBucketLocation", ] resources = [ "arn:aws:s3:::*", ] } statement { actions = [ "s3:ListBucket", ] resources = [ "arn:aws:s3:::${var.s3_bucket_name}", ] condition { test = "StringLike" variable = "s3:prefix" values = [ "", "home/", "home/&{aws:username}/", ] } } statement { actions = [ "s3:*", ] resources = [ "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}", "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}/*", ] } } resource "aws_iam_policy" "example" { name = "example_policy" path = "/" policy = data.aws_iam_policy_document.example.json }
```

### [Example Multiple Condition Keys and Values](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-multiple-condition-keys-and-values)

You can specify a [condition with multiple keys and values](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_multi-value-conditions.html) by supplying multiple `condition` blocks with the same `test` value, but differing `variable` and `values` values.

```terraform
data "aws_iam_policy_document" "example_multiple_condition_keys_and_values" { statement { actions = [ "kms:Decrypt", "kms:GenerateDataKey" ] resources = ["*"] condition { test = "ForAnyValue:StringEquals" variable = "kms:EncryptionContext:service" values = ["pi"] } condition { test = "ForAnyValue:StringEquals" variable = "kms:EncryptionContext:aws:pi:service" values = ["rds"] } condition { test = "ForAnyValue:StringEquals" variable = "kms:EncryptionContext:aws:rds:db-id" values = ["db-AAAAABBBBBCCCCCDDDDDEEEEE", "db-EEEEEDDDDDCCCCCBBBBBAAAAA"] } } }
```

`data.aws_iam_policy_document.example_multiple_condition_keys_and_values.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "kms:EncryptionContext:aws:pi:service": "rds",
          "kms:EncryptionContext:aws:rds:db-id": [
            "db-AAAAABBBBBCCCCCDDDDDEEEEE",
            "db-EEEEEDDDDDCCCCCBBBBBAAAAA"
          ],
          "kms:EncryptionContext:service": "pi"
        }
      }
    }
  ]
}
```

### [Example Assume-Role Policy with Multiple Principals](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-assume-role-policy-with-multiple-principals)

You can specify multiple principal blocks with different types. You can also use this data source to generate an assume-role policy.

```terraform
data "aws_iam_policy_document" "event_stream_bucket_role_assume_role_policy" { statement { actions = ["sts:AssumeRole"] principals { type = "Service" identifiers = ["firehose.amazonaws.com"] } principals { type = "AWS" identifiers = [var.trusted_role_arn] } principals { type = "Federated" identifiers = ["arn:aws:iam::${var.account_id}:saml-provider/${var.provider_name}", "cognito-identity.amazonaws.com"] } } }
```

### [Example Using A Source Document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-using-a-source-document)

```terraform
data "aws_iam_policy_document" "source" { statement { actions = ["ec2:*"] resources = ["*"] } statement { sid = "SidToOverride" actions = ["s3:*"] resources = ["*"] } } data "aws_iam_policy_document" "source_document_example" { source_policy_documents = [data.aws_iam_policy_document.source.json] statement { sid = "SidToOverride" actions = ["s3:*"] resources = [ "arn:aws:s3:::somebucket", "arn:aws:s3:::somebucket/*", ] } }
```

`data.aws_iam_policy_document.source_document_example.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "SidToOverride",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::somebucket/*",
        "arn:aws:s3:::somebucket"
      ]
    }
  ]
}
```

### [Example Using An Override Document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-using-an-override-document)

```terraform
data "aws_iam_policy_document" "override" { statement { sid = "SidToOverride" actions = ["s3:*"] resources = ["*"] } } data "aws_iam_policy_document" "override_policy_document_example" { override_policy_documents = [data.aws_iam_policy_document.override.json] statement { actions = ["ec2:*"] resources = ["*"] } statement { sid = "SidToOverride" actions = ["s3:*"] resources = [ "arn:aws:s3:::somebucket", "arn:aws:s3:::somebucket/*", ] } }
```

`data.aws_iam_policy_document.override_policy_document_example.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "SidToOverride",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
```

### [Example with Both Source and Override Documents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-with-both-source-and-override-documents)

You can also combine `source_policy_documents` and `override_policy_documents` in the same document.

```terraform
data "aws_iam_policy_document" "source" { statement { sid = "OverridePlaceholder" actions = ["ec2:DescribeAccountAttributes"] resources = ["*"] } } data "aws_iam_policy_document" "override" { statement { sid = "OverridePlaceholder" actions = ["s3:GetObject"] resources = ["*"] } } data "aws_iam_policy_document" "politik" { source_policy_documents = [data.aws_iam_policy_document.source.json] override_policy_documents = [data.aws_iam_policy_document.override.json] }
```

`data.aws_iam_policy_document.politik.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OverridePlaceholder",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}
```

### [Example of Merging Source Documents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-of-merging-source-documents)

Multiple documents can be combined using the `source_policy_documents` or `override_policy_documents` attributes. `source_policy_documents` requires that all documents have unique Sids, while `override_policy_documents` will iteratively override matching Sids.

```terraform
data "aws_iam_policy_document" "source_one" { statement { actions = ["ec2:*"] resources = ["*"] } statement { sid = "UniqueSidOne" actions = ["s3:*"] resources = ["*"] } } data "aws_iam_policy_document" "source_two" { statement { sid = "UniqueSidTwo" actions = ["iam:*"] resources = ["*"] } statement { actions = ["lambda:*"] resources = ["*"] } } data "aws_iam_policy_document" "combined" { source_policy_documents = [ data.aws_iam_policy_document.source_one.json, data.aws_iam_policy_document.source_two.json ] }
```

`data.aws_iam_policy_document.combined.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
    {
      "Sid": "UniqueSidOne",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Sid": "UniqueSidTwo",
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "lambda:*",
      "Resource": "*"
    }
  ]
}
```

### [Example of Merging Override Documents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#example-of-merging-override-documents)

```terraform
data "aws_iam_policy_document" "policy_one" { statement { sid = "OverridePlaceHolderOne" effect = "Allow" actions = ["s3:*"] resources = ["*"] } } data "aws_iam_policy_document" "policy_two" { statement { effect = "Allow" actions = ["ec2:*"] resources = ["*"] } statement { sid = "OverridePlaceHolderTwo" effect = "Allow" actions = ["iam:*"] resources = ["*"] } } data "aws_iam_policy_document" "policy_three" { statement { sid = "OverridePlaceHolderOne" effect = "Deny" actions = ["logs:*"] resources = ["*"] } } data "aws_iam_policy_document" "combined" { override_policy_documents = [ data.aws_iam_policy_document.policy_one.json, data.aws_iam_policy_document.policy_two.json, data.aws_iam_policy_document.policy_three.json ] statement { sid = "OverridePlaceHolderTwo" effect = "Deny" actions = ["*"] resources = ["*"] } }
```

`data.aws_iam_policy_document.combined.json` will evaluate to:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OverridePlaceholderTwo",
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    },
    {
      "Sid": "OverridePlaceholderOne",
      "Effect": "Deny",
      "Action": "logs:*",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    },
  ]
}
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#argument-reference)

The following arguments are optional:

-   [`override_policy_documents`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#override_policy_documents-1) (Optional) - List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid` from earlier documents in the list. Statements with non-blank `sid`s will also override statements with the same `sid` from `source_policy_documents`. Non-overriding statements will be added to the exported document.
-   [`policy_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#policy_id-1) (Optional) - ID for the policy document.
-   [`source_policy_documents`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#source_policy_documents-1) (Optional) - List of IAM policy documents that are merged together into the exported document. Statements defined in `source_policy_documents` must have unique `sid`s. Statements with the same `sid` from `override_policy_documents` will override source statements.
-   [`statement`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#statement-1) (Optional) - Configuration block for a policy statement. Detailed below.
-   [`version`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#version-1) (Optional) - IAM policy document version. Valid values are `2008-10-17` and `2012-10-17`. Defaults to `2012-10-17`. For more information, see the [AWS IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_version.html).

### [`statement`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#statement)

The following arguments are optional:

-   [`actions`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#actions-1) (Optional) - List of actions that this statement either allows or denies. For example, `["ec2:RunInstances", "s3:*"]`.
-   [`condition`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#condition-1) (Optional) - Configuration block for a condition. Detailed below.
-   [`effect`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#effect-1) (Optional) - Whether this statement allows or denies the given actions. Valid values are `Allow` and `Deny`. Defaults to `Allow`.
-   [`not_actions`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#not_actions-1) (Optional) - List of actions that this statement does _not_ apply to. Use to apply a policy statement to all actions _except_ those listed.
-   [`not_principals`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#not_principals-1) (Optional) - Like `principals` except these are principals that the statement does _not_ apply to.
-   [`not_resources`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#not_resources-1) (Optional) - List of resource ARNs that this statement does _not_ apply to. Use to apply a policy statement to all resources _except_ those listed. Conflicts with `resources`.
-   [`principals`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#principals-1) (Optional) - Configuration block for principals. Detailed below.
-   [`resources`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#resources-1) (Optional) - List of resource ARNs that this statement applies to. This is required by AWS if used for an IAM policy. Conflicts with `not_resources`.
-   [`sid`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#sid-1) (Optional) - Sid (statement ID) is an identifier for a policy statement.

### [`condition`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#condition)

A `condition` constrains whether a statement applies in a particular situation. Conditions can be specific to an AWS service. When using multiple `condition` blocks, they must _all_ evaluate to true for the policy statement to apply. In other words, AWS evaluates the conditions as though with an "AND" boolean operation.

The following arguments are required:

-   [`test`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#test-1) (Required) Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate.
-   [`values`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#values-1) (Required) Values to evaluate the condition against. If multiple values are provided, the condition matches if at least one of them applies. That is, AWS evaluates multiple values as though using an "OR" boolean operation.
-   [`variable`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#variable-1) (Required) Name of a [Context Variable](http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements.html#AvailableKeys) to apply the condition to. Context variables may either be standard AWS variables starting with `aws:` or service-specific variables prefixed with the service name.

### [`principals` and `not_principals`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#principals-and-not_principals)

The `principals` and `not_principals` arguments define to whom a statement applies or does not apply, respectively.

The following arguments are required:

-   [`identifiers`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#identifiers-1) (Required) List of identifiers for principals. When `type` is `AWS`, these are IAM principal ARNs, e.g., `arn:aws:iam::12345678901:role/yak-role`. When `type` is `Service`, these are AWS Service roles, e.g., `lambda.amazonaws.com`. When `type` is `Federated`, these are web identity users or SAML provider ARNs, e.g., `accounts.google.com` or `arn:aws:iam::12345678901:saml-provider/yak-saml-provider`. When `type` is `CanonicalUser`, these are [canonical user IDs](https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html#FindingCanonicalId), e.g., `79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be`.
-   [`type`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#type-1) (Required) Type of principal. Valid values include `AWS`, `Service`, `Federated`, `CanonicalUser` and `*`.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#attribute-reference)

This data source exports the following attributes in addition to the arguments above:

-   [`json`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#json-1) - Standard JSON policy document rendered based on the arguments above.
-   [`minified_json`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document.html#minified_json-1) - Minified JSON policy document rendered based on the arguments above.
