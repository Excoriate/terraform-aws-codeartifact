# Terraform AWS Resources Documentation

## Table of Contents

1. [AWS CloudWatch Log Group](#aws-cloudwatch-log-group)
2. [AWS IAM Policy](#aws-iam-policy)
3. [AWS IAM Policy Attachment](#aws-iam-policy-attachment)
4. [AWS IAM Role](#aws-iam-role)
5. [AWS IAM Role Policy](#aws-iam-role-policy)
6. [AWS IAM Role Policy Attachment](#aws-iam-role-policy-attachment)
7. [AWS KMS Alias](#aws-kms-alias)
8. [AWS KMS Key](#aws-kms-key)
9. [AWS S3 Bucket](#aws-s3-bucket)
10. [AWS S3 Bucket Policy](#aws-s3-bucket-policy)
11. [AWS S3 Bucket Server-Side Encryption Configuration](#aws-s3-bucket-server-side-encryption-configuration)
12. [AWS S3 Bucket Versioning](#aws-s3-bucket-versioning)

## AWS CloudWatch Log Group

Provides a CloudWatch Log Group resource.

### Example Usage

```terraform
resource "aws_cloudwatch_log_group" "yada" {
  name = "Yada"
  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}
```

### Argument Reference

- `name` - (Optional, Forces new resource) The name of the log group. If omitted, Terraform will assign a random, unique name.
- `name_prefix` - (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with `name`.
- `skip_destroy` - (Optional) Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time.
- `log_group_class` - (Optional) Specifies the log class of the log group. Possible values are: `STANDARD` or `INFREQUENT_ACCESS`.
- `retention_in_days` - (Optional) Specifies the number of days you want to retain log events. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0.
- `kms_key_id` - (Optional) The ARN of the KMS Key to use when encrypting log data.
- `tags` - (Optional) A map of tags to assign to the resource.

### Attribute Reference

- `arn` - The Amazon Resource Name (ARN) specifying the log group.
- `tags_all` - A map of tags assigned to the resource.

### Import

```terraform
import {
  to = aws_cloudwatch_log_group.test_group
  id = "yada"
}
```

## AWS IAM Policy

Provides an IAM policy.

### Example Usage

```terraform
resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["ec2:Describe*"]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

### Argument Reference

- `description` - (Optional, Forces new resource) Description of the IAM policy.
- `name_prefix` - (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with `name`.
- `name` - (Optional, Forces new resource) Name of the policy.
- `path` - (Optional, default "/") Path in which to create the policy.
- `policy` - (Required) Policy document as a JSON formatted string.
- `tags` - (Optional) Map of resource tags.

### Attribute Reference

- `arn` - ARN assigned by AWS to this policy.
- `attachment_count` - Number of entities the policy is attached to.
- `id` - ARN assigned by AWS to this policy.
- `policy_id` - Policy's ID.
- `tags_all` - A map of tags assigned to the resource.

### Import

```terraform
import {
  to = aws_iam_policy.administrator
  id = "arn:aws:iam::123456789012:policy/UsersManageOwnCredentials"
}
```

## AWS IAM Policy Attachment

Attaches a Managed IAM Policy to user(s), role(s), and/or group(s)

### Example Usage

```terraform
resource "aws_iam_user" "user" { name = "test-user" }
resource "aws_iam_role" "role" { name = "test-role" }
resource "aws_iam_group" "group" { name = "test-group" }
resource "aws_iam_policy" "policy" { name = "test-policy" }

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}
```

### Argument Reference

- `name` - (Required) Name of the attachment.
- `users` - (Optional) User(s) the policy should be applied to.
- `roles` - (Optional) Role(s) the policy should be applied to.
- `groups` - (Optional) Group(s) the policy should be applied to.
- `policy_arn` - (Required) ARN of the policy to apply.

### Attribute Reference

- `id` - Policy's ID.
- `name` - Name of the attachment.

### Import

```terraform
import {
  to = aws_iam_policy_attachment.test-attach
  id = "test-role/arn:aws:iam::xxxxxxxxxxxx:policy/test-policy"
}
```

## AWS IAM Role

Provides an IAM role.

### Example Usage

```terraform
resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
```

### Argument Reference

- `assume_role_policy` - (Required) Policy that grants an entity permission to assume the role.
- `description` - (Optional) Description of the role.
- `force_detach_policies` - (Optional) Whether to force detaching any policies before destroying. Defaults to `false`.
- `inline_policy` - (Optional, Deprecated) Configuration block defining IAM inline policies.
- `managed_policy_arns` - (Optional, Deprecated) Set of exclusive IAM managed policy ARNs to attach to the role.
- `max_session_duration` - (Optional) Maximum session duration (1-12 hours).
- `name` - (Optional, Forces new resource) Friendly name of the role.
- `name_prefix` - (Optional, Forces new resource) Creates a unique name beginning with the specified prefix.
- `path` - (Optional) Path to the role.
- `permissions_boundary` - (Optional) ARN of the policy that is used to set the permissions boundary for the role.
- `tags` - (Optional) Key-value mapping of tags.

### Attribute Reference

- `arn` - Amazon Resource Name (ARN) specifying the role.
- `create_date` - Creation date of the IAM role.
- `id` - Name of the role.
- `name` - Name of the role.
- `tags_all` - A map of tags assigned to the resource.
- `unique_id` - Stable and unique string identifying the role.

### Import

```terraform
import {
  to = aws_iam_role.developer
  id = "developer_name"
}
```

## AWS IAM Role Policy

Provides an IAM role inline policy.

### Example Usage

```terraform
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["ec2:Describe*"]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
```

### Argument Reference

- `name` - (Optional) The name of the role policy. If omitted, Terraform will assign a random, unique name.
- `name_prefix` - (Optional) Creates a unique name beginning with the specified prefix.
- `policy` - (Required) The inline policy document as a JSON formatted string.
- `role` - (Required) The name of the IAM role to attach to the policy.

### Attribute Reference

- `id` - The role policy ID, in the form of `role_name:role_policy_name`.
- `name` - The name of the policy.
- `policy` - The policy document attached to the role.
- `role` - The name of the role associated with the policy.

### Import

```terraform
import {
  to = aws_iam_role_policy.mypolicy
  id = "role_of_mypolicy_name:mypolicy_name"
}
```

## AWS IAM Role Policy Attachment

Attaches a Managed IAM Policy to an IAM role

### Example Usage

```terraform
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
```

### Argument Reference

- `role` - (Required) The name of the IAM role to which the policy should be applied.
- `policy_arn` - (Required) The ARN of the policy you want to apply.

### Attribute Reference

This resource exports no additional attributes.

### Import

```terraform
import {
  to = aws_iam_role_policy_attachment.test-attach
  id = "test-role/arn:aws:iam::xxxxxxxxxxxx:policy/test-policy"
}
```

## AWS KMS Alias

Provides an alias for a KMS customer master key.

### Example Usage

```terraform
resource "aws_kms_key" "a" {}

resource "aws_kms_alias" "a" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.a.key_id
}
```

### Argument Reference

- `name` - (Optional) The display name of the alias. Must start with "alias/" followed by a forward slash.
- `name_prefix` - (Optional) Creates a unique alias beginning with the specified prefix. Conflicts with `name`.
- `target_key_id` - (Required) Identifier for the key for which the alias is for, can be either an ARN or key_id.

### Attribute Reference

- `arn` - The Amazon Resource Name (ARN) of the key alias.
- `target_key_arn` - The Amazon Resource Name (ARN) of the target key identifier.

### Import

```terraform
import {
  to = aws_kms_alias.a
  id = "alias/my-key-alias"
}
```

## AWS KMS Key

Manages a single-Region or multi-Region primary KMS key.

### Example Usage: Symmetric Encryption KMS Key

```terraform
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "example" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}
```

### Argument Reference

- `description` - (Optional) The description of the key as viewed in AWS console.
- `key_usage` - (Optional) Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT`, `SIGN_VERIFY`, or `GENERATE_VERIFY_MAC`. Defaults to `ENCRYPT_DECRYPT`.
- `custom_key_store_id` - (Optional) ID of the KMS Custom Key Store.
- `customer_master_key_spec` - (Optional) Specifies the key specification. Valid values include `SYMMETRIC_DEFAULT`, `RSA_2048`, `HMAC_256`, etc.
- `policy` - (Optional) A valid policy JSON document for the key.
- `bypass_policy_lockout_safety_check` - (Optional) A flag to indicate whether to bypass the key policy lockout safety check.
- `deletion_window_in_days` - (Optional) The waiting period for key deletion (7-30 days).
- `is_enabled` - (Optional) Specifies whether the key is enabled. Defaults to `true`.
- `enable_key_rotation` - (Optional) Specifies whether key rotation is enabled.
- `rotation_period_in_days` - (Optional) Custom period between key rotations (90-2560 days).
- `multi_region` - (Optional) Indicates whether the key is multi-Region. Defaults to `false`.
- `tags` - (Optional) A map of tags to assign to the object.

### Attribute Reference

- `arn` - The Amazon Resource Name (ARN) of the key.
- `key_id` - The globally unique identifier for the key.
- `tags_all` - A map of tags assigned to the resource.

### Import

```terraform
import {
  to = aws_kms_key.a
  id = "1234abcd-12ab-34cd-56ef-1234567890ab"
}
```

## AWS S3 Bucket

Provides an S3 bucket resource for storing and managing artifacts, backups, and migration data.

### Example Usage

```terraform
resource "aws_s3_bucket" "codeartifact_backup" {
  bucket = "my-codeartifact-backup-bucket"

  tags = {
    Name        = "CodeArtifact Backup Bucket"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Argument Reference

- `bucket` - (Optional) Name of the bucket. If omitted, Terraform will assign a random, unique name.
- `bucket_prefix` - (Optional) Creates a unique bucket name beginning with the specified prefix.
- `force_destroy` - (Optional, Default: `false`) Allows bucket deletion even with non-empty contents.
- `object_lock_enabled` - (Optional) Indicates whether this bucket has an Object Lock configuration.
- `tags` - (Optional) Map of tags to assign to the bucket.

### Attribute Reference

- `id` - Name of the bucket.
- `arn` - ARN of the bucket.
- `bucket_domain_name` - Bucket domain name.
- `region` - AWS region this bucket resides in.

## AWS S3 Bucket Policy

Attaches a policy to an S3 bucket resource, defining access controls and permissions.

### Example Usage

```terraform
resource "aws_s3_bucket_policy" "codeartifact_backup_policy" {
  bucket = aws_s3_bucket.codeartifact_backup.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCodeArtifactAccess"
        Effect    = "Allow"
        Principal = { Service = "codeartifact.amazonaws.com" }
        Action    = ["s3:GetObject", "s3:PutObject"]
        Resource  = [
          "${aws_s3_bucket.codeartifact_backup.arn}",
          "${aws_s3_bucket.codeartifact_backup.arn}/*"
        ]
      }
    ]
  })
}
```

### Argument Reference

- `bucket` - (Required) Name of the bucket to apply the policy.
- `policy` - (Required) JSON text of the bucket policy.

## AWS S3 Bucket Server-Side Encryption Configuration

Configures server-side encryption for an S3 bucket to enhance data security.

### Example Usage

```terraform
resource "aws_kms_key" "codeartifact_encryption_key" {
  description             = "KMS key for CodeArtifact S3 bucket encryption"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codeartifact_encryption" {
  bucket = aws_s3_bucket.codeartifact_backup.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.codeartifact_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
```

### Argument Reference

- `bucket` - (Required) ID of the bucket.
- `rule` - (Required) Server-side encryption configuration rules.
  - `apply_server_side_encryption_by_default` - Configuration for default encryption.
    - `sse_algorithm` - Server-side encryption algorithm.
    - `kms_master_key_id` - AWS KMS master key ID for encryption.

## AWS S3 Bucket Versioning

Manages versioning configuration for an S3 bucket to track and preserve object versions.

### Example Usage

```terraform
resource "aws_s3_bucket_versioning" "codeartifact_versioning" {
  bucket = aws_s3_bucket.codeartifact_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

### Argument Reference

- `bucket` - (Required) Name of the S3 bucket.
- `versioning_configuration` - (Required) Versioning configuration block.
  - `status` - Versioning state (`Enabled`, `Suspended`, or `Disabled`).
  - `mfa_delete` - (Optional) MFA delete configuration.
