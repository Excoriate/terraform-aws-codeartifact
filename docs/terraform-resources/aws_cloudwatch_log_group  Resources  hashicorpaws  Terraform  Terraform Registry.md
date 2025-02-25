Provides a CloudWatch Log Group resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

```terraform
resource "aws_cloudwatch_log_group" "yada" { name = "Yada" tags = { Environment = "production" Application = "serviceA" } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name-2) - (Optional, Forces new resource) The name of the log group. If omitted, Terraform will assign a random, unique name.
-   [`name_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#name_prefix-2) - (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with `name`.
-   [`skip_destroy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#skip_destroy-1) - (Optional) Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state.
-   [`log_group_class`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#log_group_class-1) - (Optional) Specified the log class of the log group. Possible values are: `STANDARD` or `INFREQUENT_ACCESS`.
-   [`retention_in_days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#retention_in_days-1) - (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire.
-   [`kms_key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#kms_key_id-1) - (Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-4) - (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn-3) - The Amazon Resource Name (ARN) specifying the log group. Any `:*` suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags_all-2) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import Cloudwatch Log Groups using the `name`. For example:

```terraform
import { to = aws_cloudwatch_log_group.test_group id = "yada" }
```

Using `terraform import`, import Cloudwatch Log Groups using the `name`. For example:

```console
% terraform import aws_cloudwatch_log_group.test_group yada
```
