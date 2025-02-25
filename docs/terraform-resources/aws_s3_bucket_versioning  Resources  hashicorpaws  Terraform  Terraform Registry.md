Provides a resource for controlling versioning on an S3 bucket. Deleting this resource will either suspend versioning on the associated S3 bucket or simply remove the resource from Terraform state if the associated S3 bucket is unversioned.

For more information, see [How S3 versioning works](https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html).

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

### [With Versioning Enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#with-versioning-enabled)

```terraform
resource "aws_s3_bucket" "example" { bucket = "example-bucket" } resource "aws_s3_bucket_acl" "example" { bucket = aws_s3_bucket.example.id acl = "private" } resource "aws_s3_bucket_versioning" "versioning_example" { bucket = aws_s3_bucket.example.id versioning_configuration { status = "Enabled" } }
```

### [With Versioning Disabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#with-versioning-disabled)

```terraform
resource "aws_s3_bucket" "example" { bucket = "example-bucket" } resource "aws_s3_bucket_acl" "example" { bucket = aws_s3_bucket.example.id acl = "private" } resource "aws_s3_bucket_versioning" "versioning_example" { bucket = aws_s3_bucket.example.id versioning_configuration { status = "Disabled" } }
```

### [Object Dependency On Versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object-dependency-on-versioning)

When you create an object whose `version_id` you need and an `aws_s3_bucket_versioning` resource in the same configuration, you are more likely to have success by ensuring the `s3_object` depends either implicitly (see below) or explicitly (i.e., using `depends_on = [aws_s3_bucket_versioning.example]`) on the `aws_s3_bucket_versioning` resource.

This example shows the `aws_s3_object.example` depending implicitly on the versioning resource through the reference to `aws_s3_bucket_versioning.example.bucket` to define `bucket`:

```terraform
resource "aws_s3_bucket" "example" { bucket = "yotto" } resource "aws_s3_bucket_versioning" "example" { bucket = aws_s3_bucket.example.id versioning_configuration { status = "Enabled" } } resource "aws_s3_object" "example" { bucket = aws_s3_bucket_versioning.example.id key = "droeloe" source = "example.txt" }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket-6) - (Required, Forces new resource) Name of the S3 bucket.
-   [`versioning_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning_configuration-1) - (Required) Configuration block for the versioning parameters. [See below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning_configuration).
-   [`expected_bucket_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expected_bucket_owner-3) - (Optional, Forces new resource) Account ID of the expected bucket owner.
-   [`mfa`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#mfa-1) - (Optional, Required if `versioning_configuration` `mfa_delete` is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.

### [versioning\_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning_configuration)

The `versioning_configuration` configuration block supports the following arguments:

-   [`status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#status-4) - (Required) Versioning state of the bucket. Valid values: `Enabled`, `Suspended`, or `Disabled`. `Disabled` should only be used when creating or importing resources that correspond to unversioned S3 buckets.
-   [`mfa_delete`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#mfa_delete-2) - (Optional) Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: `Enabled` or `Disabled`.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-12) - The `bucket` or `bucket` and `expected_bucket_owner` separated by a comma (`,`) if the latter is provided.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import S3 bucket versioning using the `bucket` or using the `bucket` and `expected_bucket_owner` separated by a comma (`,`). For example:

If the owner (account ID) of the source bucket is the same account used to configure the Terraform AWS Provider, import using the `bucket`:

```terraform
import { to = aws_s3_bucket_versioning.example id = "bucket-name" }
```

If the owner (account ID) of the source bucket differs from the account used to configure the Terraform AWS Provider, import using the `bucket` and `expected_bucket_owner` separated by a comma (`,`):

```terraform
import { to = aws_s3_bucket_versioning.example id = "bucket-name,123456789012" }
```

**Using `terraform import` to import** S3 bucket versioning using the `bucket` or using the `bucket` and `expected_bucket_owner` separated by a comma (`,`). For example:

If the owner (account ID) of the source bucket is the same account used to configure the Terraform AWS Provider, import using the `bucket`:

```console
% terraform import aws_s3_bucket_versioning.example bucket-name
```

If the owner (account ID) of the source bucket differs from the account used to configure the Terraform AWS Provider, import using the `bucket` and `expected_bucket_owner` separated by a comma (`,`):

```console
% terraform import aws_s3_bucket_versioning.example bucket-name,123456789012
```
