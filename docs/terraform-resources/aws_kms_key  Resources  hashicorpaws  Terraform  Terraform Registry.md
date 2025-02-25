## Resource: aws\_kms\_key

Manages a single-Region or multi-Region primary KMS key.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

### [Symmetric Encryption KMS Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#symmetric-encryption-kms-key)

```terraform
data "aws_caller_identity" "current" {} resource "aws_kms_key" "example" { description = "An example symmetric encryption KMS key" enable_key_rotation = true deletion_window_in_days = 20 policy = jsonencode({ Version = "2012-10-17" Id = "key-default-1" Statement = [ { Sid = "Enable IAM User Permissions" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }, Action = "kms:*" Resource = "*" }, { Sid = "Allow administration of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice" }, Action = [ "kms:ReplicateKey", "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*", "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion" ], Resource = "*" }, { Sid = "Allow use of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Bob" }, Action = [ "kms:DescribeKey", "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey", "kms:GenerateDataKeyWithoutPlaintext" ], Resource = "*" } ] }) }
```

### [Symmetric Encryption KMS Key With Standalone Policy Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#symmetric-encryption-kms-key-with-standalone-policy-resource)

```terraform
data "aws_caller_identity" "current" {} resource "aws_kms_key" "example" { description = "An example symmetric encryption KMS key" enable_key_rotation = true deletion_window_in_days = 20 } resource "aws_kms_key_policy" "example" { key_id = aws_kms_key.example.id policy = jsonencode({ Version = "2012-10-17" Id = "key-default-1" Statement = [ { Sid = "Enable IAM User Permissions" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }, Action = "kms:*" Resource = "*" } ] }) }
```

### [Asymmetric KMS Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#asymmetric-kms-key)

```terraform
data "aws_caller_identity" "current" {} resource "aws_kms_key" "example" { description = "RSA-3072 asymmetric KMS key for signing and verification" customer_master_key_spec = "RSA_3072" key_usage = "SIGN_VERIFY" enable_key_rotation = false policy = jsonencode({ Version = "2012-10-17" Id = "key-default-1" Statement = [ { Sid = "Enable IAM User Permissions" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }, Action = "kms:*" Resource = "*" }, { Sid = "Allow administration of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin" }, Action = [ "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*", "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion" ], Resource = "*" }, { Sid = "Allow use of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Developer" }, Action = [ "kms:Sign", "kms:Verify", "kms:DescribeKey" ], Resource = "*" } ] }) }
```

### [HMAC KMS key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#hmac-kms-key)

```terraform
data "aws_caller_identity" "current" {} resource "aws_kms_key" "example" { description = "HMAC_384 key for tokens" customer_master_key_spec = "HMAC_384" key_usage = "GENERATE_VERIFY_MAC" enable_key_rotation = false policy = jsonencode({ Version = "2012-10-17" Id = "key-default-1" Statement = [ { Sid = "Enable IAM User Permissions" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }, Action = "kms:*" Resource = "*" }, { Sid = "Allow administration of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin" }, Action = [ "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*", "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion" ], Resource = "*" }, { Sid = "Allow use of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Developer" }, Action = [ "kms:GenerateMac", "kms:VerifyMac", "kms:DescribeKey" ], Resource = "*" } ] }) }
```

### [Multi-Region Primary Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#multi-region-primary-key)

```terraform
data "aws_caller_identity" "current" {} resource "aws_kms_key" "example" { description = "An example multi-Region primary key" multi_region = true enable_key_rotation = true deletion_window_in_days = 10 policy = jsonencode({ Version = "2012-10-17" Id = "key-default-1" Statement = [ { Sid = "Enable IAM User Permissions" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }, Action = "kms:*" Resource = "*" }, { Sid = "Allow administration of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Alice" }, Action = [ "kms:ReplicateKey", "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*", "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*", "kms:ScheduleKeyDeletion", "kms:CancelKeyDeletion" ], Resource = "*" }, { Sid = "Allow use of the key" Effect = "Allow" Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Bob" }, Action = [ "kms:DescribeKey", "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey", "kms:GenerateDataKeyWithoutPlaintext" ], Resource = "*" } ] }) }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`description`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#description-1) - (Optional) The description of the key as viewed in AWS console.
-   [`key_usage`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#key_usage-1) - (Optional) Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`. Defaults to `ENCRYPT_DECRYPT`.
-   [`custom_key_store_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#custom_key_store_id-1) - (Optional) ID of the KMS [Custom Key Store](https://docs.aws.amazon.com/kms/latest/developerguide/create-cmk-keystore.html) where the key will be stored instead of KMS (eg CloudHSM).
-   [`customer_master_key_spec`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#customer_master_key_spec-1) - (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`. For help with choosing a key spec, see the [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/symm-asymm-choose.html).
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-3) - (Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an [`aws_iam_policy_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document), in the form that designates a principal, can be used. For more information about building policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy).

-   [`bypass_policy_lockout_safety_check`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bypass_policy_lockout_safety_check-1) - (Optional) A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the [Default Key Policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam) section in the _AWS Key Management Service Developer Guide_. The default value is `false`.
-   [`deletion_window_in_days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#deletion_window_in_days-1) - (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately.
-   [`is_enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#is_enabled-1) - (Optional) Specifies whether the key is enabled. Defaults to `true`.
-   [`enable_key_rotation`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#enable_key_rotation-1) - (Optional, required to be enabled if `rotation_period_in_days` is specified) Specifies whether [key rotation](http://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html) is enabled. Defaults to `false`.
-   [`rotation_period_in_days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rotation_period_in_days-1) - (Optional) Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive).
-   [`multi_region`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#multi_region-1) - (Optional) Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-3) - (Optional) A map of tags to assign to the object. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.
-   [`xks_key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#xks_key_id-1) - (Optional) Identifies the external key that serves as key material for the KMS key in an external key store.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn-1) - The Amazon Resource Name (ARN) of the key.
-   [`key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#key_id-1) - The globally unique identifier for the key.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags_all-1) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Timeouts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#timeouts)

[Configuration options](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts):

-   [`create`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#create-1) - (Default `2m`)

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import KMS Keys using the `id`. For example:

```terraform
import { to = aws_kms_key.a id = "1234abcd-12ab-34cd-56ef-1234567890ab" }
```

Using `terraform import`, import KMS Keys using the `id`. For example:

```console
% terraform import aws_kms_key.a 1234abcd-12ab-34cd-56ef-1234567890ab
```
