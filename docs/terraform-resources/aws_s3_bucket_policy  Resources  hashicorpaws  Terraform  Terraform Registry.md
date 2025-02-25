## Resource: aws\_s3\_bucket\_policy

Attaches a policy to an S3 bucket resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

### [Basic Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#basic-usage)

```terraform
resource "aws_s3_bucket" "example" { bucket = "my-tf-test-bucket" } resource "aws_s3_bucket_policy" "allow_access_from_another_account" { bucket = aws_s3_bucket.example.id policy = data.aws_iam_policy_document.allow_access_from_another_account.json } data "aws_iam_policy_document" "allow_access_from_another_account" { statement { principals { type = "AWS" identifiers = ["123456789012"] } actions = [ "s3:GetObject", "s3:ListBucket", ] resources = [ aws_s3_bucket.example.arn, "${aws_s3_bucket.example.arn}/*", ] } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket-4) - (Required) Name of the bucket to which to apply the policy.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-9) - (Required) Text of the policy. Although this is a bucket policy rather than an IAM policy, the [`aws_iam_policy_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). Note: Bucket policies are limited to 20 KB in size.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports no additional attributes.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import S3 bucket policies using the bucket name. For example:

```terraform
import { to = aws_s3_bucket_policy.allow_access_from_another_account id = "my-tf-test-bucket" }
```

Using `terraform import`, import S3 bucket policies using the bucket name. For example:

```console
% terraform import aws_s3_bucket_policy.allow_access_from_another_account my-tf-test-bucket
```
