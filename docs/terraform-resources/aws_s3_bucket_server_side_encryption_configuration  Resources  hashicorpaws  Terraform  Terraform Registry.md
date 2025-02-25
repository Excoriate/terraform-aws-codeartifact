Provides a S3 bucket server-side encryption configuration resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
resource "aws_kms_key" "mykey" { description = "This key is used to encrypt bucket objects" deletion_window_in_days = 10 } resource "aws_s3_bucket" "mybucket" { bucket = "mybucket" } resource "aws_s3_bucket_server_side_encryption_configuration" "example" { bucket = aws_s3_bucket.mybucket.id rule { apply_server_side_encryption_by_default { kms_master_key_id = aws_kms_key.mykey.arn sse_algorithm = "aws:kms" } } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket-5) - (Required, Forces new resource) ID (name) of the bucket.
-   [`expected_bucket_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expected_bucket_owner-2) - (Optional, Forces new resource) Account ID of the expected bucket owner.
-   [`rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule-3) - (Required) Set of server-side encryption configuration rules. [See below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule). Currently, only a single rule is supported.

### [rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule)

The `rule` configuration block supports the following arguments:

-   [`apply_server_side_encryption_by_default`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#apply_server_side_encryption_by_default-2) - (Optional) Single object for setting server-side encryption by default. [See below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#apply_server_side_encryption_by_default).
-   [`bucket_key_enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket_key_enabled-2) - (Optional) Whether or not to use [Amazon S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-key.html) for SSE-KMS.

### [apply\_server\_side\_encryption\_by\_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#apply_server_side_encryption_by_default)

The `apply_server_side_encryption_by_default` configuration block supports the following arguments:

-   [`sse_algorithm`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#sse_algorithm-2) - (Required) Server-side encryption algorithm to use. Valid values are `AES256`, `aws:kms`, and `aws:kms:dsse`
-   [`kms_master_key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#kms_master_key_id-2) - (Optional) AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default `aws/s3` AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-11) - The `bucket` or `bucket` and `expected_bucket_owner` separated by a comma (`,`) if the latter is provided.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import S3 bucket server-side encryption configuration using the `bucket` or using the `bucket` and `expected_bucket_owner` separated by a comma (`,`). For example:

If the owner (account ID) of the source bucket is the same account used to configure the Terraform AWS Provider, import using the `bucket`:

```terraform
import { to = aws_s3_bucket_server_side_encryption_configuration.example id = "bucket-name" }
```

If the owner (account ID) of the source bucket differs from the account used to configure the Terraform AWS Provider, import using the `bucket` and `expected_bucket_owner` separated by a comma (`,`):

```terraform
import { to = aws_s3_bucket_server_side_encryption_configuration.example id = "bucket-name,123456789012" }
```

**Using `terraform import` to import** S3 bucket server-side encryption configuration using the `bucket` or using the `bucket` and `expected_bucket_owner` separated by a comma (`,`). For example:

If the owner (account ID) of the source bucket is the same account used to configure the Terraform AWS Provider, import using the `bucket`:

```console
% terraform import aws_s3_bucket_server_side_encryption_configuration.example bucket-name
```

If the owner (account ID) of the source bucket differs from the account used to configure the Terraform AWS Provider, import using the `bucket` and `expected_bucket_owner` separated by a comma (`,`):

```console
% terraform import aws_s3_bucket_server_side_encryption_configuration.example bucket-name,123456789012
```
