<!-- BEGIN_TF_DOCS -->
# AWS CodeArtifact Foundation Module

This Terraform module provisions the foundational resources required for AWS CodeArtifact operations. It sets up the necessary infrastructure components for secure artifact management, including encryption, logging, and backup capabilities.

## Overview

The module creates and manages the following AWS resources:

1. **KMS Key and Alias**
   - Dedicated KMS key for encrypting CodeArtifact artifacts and S3 bucket objects
   - Custom alias for easy key identification and management
   - Configurable deletion window for key protection

2. **CloudWatch Log Group**
   - Centralized logging for CodeArtifact audit events
   - Configurable log retention period
   - Optional KMS encryption for log data

3. **S3 Bucket**
   - Secure storage for CodeArtifact backups and migration artifacts
   - Versioning enabled for data protection
   - Server-side encryption using KMS or AES256
   - Public access blocked by default

## Default Permissions Overview

### KMS Key Default Permissions

| Principal | Permission Type | Actions | Use Case |
|-----------|----------------|----------|-----------|
| Root Account | Administrative | `kms:Create*`, `kms:Describe*`, `kms:Enable*`, `kms:List*`, `kms:Put*`, `kms:Update*`, `kms:Revoke*`, `kms:Disable*`, `kms:Get*`, `kms:Delete*`, `kms:ScheduleKeyDeletion`, `kms:CancelKeyDeletion` | Key administration and lifecycle management |
| CodeArtifact Service | Encryption Operations | `kms:Decrypt`, `kms:Encrypt`, `kms:GenerateDataKey`, `kms:ReEncrypt*` | Artifact encryption/decryption |
| S3 Service | Encryption Operations | `kms:Decrypt`, `kms:GenerateDataKey` | S3 object encryption |
| CloudWatch Logs | Encryption Operations | `kms:Encrypt*`, `kms:Decrypt*`, `kms:ReEncrypt*`, `kms:GenerateDataKey*`, `kms:Describe*` | Log data encryption |

### S3 Bucket Default Permissions

| Feature | Default Configuration | Customization Options | Use Case |
|---------|---------------------|----------------------|-----------|
| Public Access | All public access blocked | Not customizable | Security baseline |
| Versioning | Enabled | Not customizable | Data protection |
| Default Access | Account owner full access | Customizable via `additional_bucket_policies` or `s3_bucket_policy_override` | Basic operations |
| Encryption | SSE-KMS (if KMS enabled) or AES256 | Encryption type fixed, key customizable | Data protection |

## Permission Customization

### S3 Bucket Policy Customization Options

| Customization Method | Use Case | Example |
|---------------------|-----------|---------|
| `additional_bucket_policies` | Add permissions while keeping defaults | Cross-account read access, service integrations |
| `s3_bucket_policy_override` | Complete policy replacement | Custom IAM roles, complex access patterns |

#### Common Use Cases and Policy Templates

1. **Cross-Account Access**
```hcl
additional_bucket_policies = [
  {
    sid     = "AllowCrossAccountAccess"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    principals = {
      type        = "AWS"
      identifiers = ["arn:aws:iam::ACCOUNT-ID:root"]
    }
    resources = ["arn:aws:s3:::BUCKET-NAME/*"]
  }
]
```

2. **Service Integration with Conditions**
```hcl
additional_bucket_policies = [
  {
    sid     = "AllowServiceAccess"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals = {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = ["arn:aws:s3:::BUCKET-NAME/*"]
    condition = {
      "StringEquals" = {
        "AWS:SourceArn" = "arn:aws:cloudfront::ACCOUNT-ID:distribution/DIST-ID"
      }
    }
  }
]
```

3. **Complete Policy Override Example**
```hcl
s3_bucket_policy_override = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Sid    = "AllowPartnerAccess"
      Effect = "Allow"
      Principal = {
        AWS = ["arn:aws:iam::PARTNER-ACCOUNT:role/SPECIFIC-ROLE"]
      }
      Action = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
      Resource = [
        "arn:aws:s3:::BUCKET-NAME",
        "arn:aws:s3:::BUCKET-NAME/*"
      ]
    }
  ]
})
```

## Features

- **Modular Design**: Each component can be enabled/disabled independently using feature flags (`is_kms_key_enabled`, `is_log_group_enabled`, `is_s3_bucket_enabled`)
- **Secure by Default**: Implements AWS security best practices
- **Flexible Configuration**: Customizable through variables
- **Comprehensive Logging**: Audit trail for all CodeArtifact operations
- **Data Protection**: Encryption at rest for all sensitive data

## Usage

```hcl
module "codeartifact_foundation" {
  source = "../../modules/foundation"

  # Feature Flags
  is_enabled = true

  # KMS Configuration
  kms_key_deletion_window = 7
  kms_key_alias          = "alias/codeartifact-encryption"

  # CloudWatch Logs Configuration
  log_group_name           = "/aws/codeartifact/audit-logs"
  log_group_retention_days = 30

  # S3 Configuration
  s3_bucket_name       = "my-company-codeartifact-backup"
  force_destroy_bucket = false

  # Resource Tags
  tags = {
    Environment = "production"
    Project     = "codeartifact"
    ManagedBy   = "terraform"
  }
}
```

## Security Features

1. **Encryption**
   - KMS encryption for artifacts and backups
   - Optional encryption for CloudWatch logs
   - Server-side encryption for S3 objects

2. **Access Control**
   - S3 bucket public access blocked
   - KMS key policy with least privilege
   - CloudWatch logs encryption

3. **Data Protection**
   - S3 bucket versioning
   - Configurable log retention
   - Protected KMS key deletion

## Best Practices

1. **Resource Naming**
   - Use descriptive names for resources
   - Follow organizational naming conventions
   - Include environment or purpose in names

2. **Security**
   - Enable KMS encryption for sensitive data
   - Set appropriate log retention periods
   - Block public access to S3 buckets

3. **Cost Management**
   - Monitor CloudWatch log retention
   - Clean up unused backups
   - Use appropriate KMS key policies

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.88.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Specifies the display name for the KMS key. The alias makes it easier to identify the key's purpose and manage it in the AWS Console. The alias name must begin with 'alias/' followed by a name that helps identify the key's purpose, such as 'alias/codeartifact-encryption'. This alias will be used consistently across the AWS account to reference this specific KMS key. | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Defines the name of the CloudWatch Log Group where CodeArtifact audit logs will be stored. The name should be descriptive and follow your organization's naming conventions. For example, '/aws/codeartifact/audit-logs' clearly indicates the purpose of the log group. This name will be used to identify and access the logs in CloudWatch, so choose a name that makes it easy to find and manage the logs. | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Specifies the name of the S3 bucket that will store CodeArtifact backups and migration artifacts. The bucket name must be globally unique across all AWS accounts and regions. It should follow AWS S3 naming rules: use only lowercase letters, numbers, dots (.), and hyphens (-), start with a letter or number, and be between 3 and 63 characters long. Choose a name that reflects the bucket's purpose and your organization's naming scheme. | `string` | n/a | yes |
| <a name="input_additional_bucket_policies"></a> [additional\_bucket\_policies](#input\_additional\_bucket\_policies) | List of additional bucket policy statements to be added to the default bucket policy.<br/>This allows extending the default policy without completely replacing it.<br/><br/>**STRUCTURE**:<br/>- sid: Unique statement identifier<br/>- effect: "Allow" or "Deny"<br/>- actions: List of S3 actions<br/>- principals: IAM principals to grant access<br/>  - type: Principal type (e.g., "AWS", "Service")<br/>  - identifiers: List of principal identifiers<br/>- resources: List of S3 resource ARNs<br/>- condition: Optional condition block (map of condition operators to values)<br/><br/>**USAGE EXAMPLE**:<pre>hcl<br/>additional_bucket_policies = [<br/>  {<br/>    sid     = "AllowCrossAccountAccess"<br/>    effect  = "Allow"<br/>    actions = ["s3:GetObject", "s3:ListBucket"]<br/>    principals = {<br/>      type        = "AWS"<br/>      identifiers = ["arn:aws:iam::ACCOUNT-ID:root"]<br/>    }<br/>    resources = ["arn:aws:s3:::BUCKET-NAME/*"]<br/>  }<br/>]</pre> | <pre>list(object({<br/>    sid     = string<br/>    effect  = string<br/>    actions = list(string)<br/>    principals = object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })<br/>    resources = list(string)<br/>    condition = optional(map(map(string)), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket to create. If not provided, a default name will be generated using the pattern:<br/>codeartifact-[account-id]<br/><br/>**NAMING CONSTRAINTS**:<br/>- Must be lowercase<br/>- Must be between 3 and 63 characters<br/>- Can contain only letters, numbers, dots (.), and hyphens (-)<br/>- Must begin and end with a letter or number<br/>- Must not be formatted as an IP address | `string` | `null` | no |
| <a name="input_codeartifact_domain_name"></a> [codeartifact\_domain\_name](#input\_codeartifact\_domain\_name) | The name of the CodeArtifact domain to create. If it's not set, it'll default to 'awsca-default'. | `string` | `"awsca-default"` | no |
| <a name="input_force_destroy_bucket"></a> [force\_destroy\_bucket](#input\_force\_destroy\_bucket) | Controls whether the S3 bucket can be forcefully deleted even when it contains objects. When set to true, all objects (including all versions and delete markers) in the bucket will be deleted automatically when the bucket is destroyed. This is useful for development environments or when you're certain that the bucket contents can be deleted. However, use this option with caution in production environments to prevent accidental data loss. | `bool` | `false` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls whether to create any resources in this module. When set to false, no resources will be created regardless of other variable settings. This is useful for conditional resource creation or temporary resource disablement without removing the module configuration. | `bool` | `true` | no |
| <a name="input_is_kms_key_enabled"></a> [is\_kms\_key\_enabled](#input\_is\_kms\_key\_enabled) | Controls whether to create the KMS key and alias for CodeArtifact encryption.<br/>When enabled, a dedicated KMS key will be created for encrypting CodeArtifact artifacts<br/>and related resources. This key will also be used for S3 bucket encryption if both<br/>KMS and S3 features are enabled.<br/><br/>Default: true (creates KMS key and alias) | `bool` | `true` | no |
| <a name="input_is_log_group_enabled"></a> [is\_log\_group\_enabled](#input\_is\_log\_group\_enabled) | Controls whether to create the CloudWatch Log Group for CodeArtifact audit logs.<br/>When enabled, a dedicated log group will be created to store and manage CodeArtifact<br/>audit logs with the specified retention period. If KMS encryption is also enabled,<br/>the logs will be encrypted using the created KMS key.<br/><br/>Default: true (creates CloudWatch Log Group) | `bool` | `true` | no |
| <a name="input_is_s3_bucket_enabled"></a> [is\_s3\_bucket\_enabled](#input\_is\_s3\_bucket\_enabled) | Controls whether to create the S3 bucket for CodeArtifact backups and artifacts.<br/>When enabled, a dedicated S3 bucket will be created with versioning enabled and<br/>public access blocked. If KMS encryption is also enabled, the bucket will use<br/>the created KMS key for encryption.<br/><br/>Default: true (creates S3 bucket) | `bool` | `true` | no |
| <a name="input_kms_key_deletion_window"></a> [kms\_key\_deletion\_window](#input\_kms\_key\_deletion\_window) | Specifies the duration in days that AWS KMS waits before permanently deleting the KMS key. This waiting period provides a safeguard against accidental deletion by allowing time for key recovery if needed. The value must be between 7 and 30 days, with a recommended minimum of 7 days to ensure adequate time for key recovery in case of accidental deletion. | `number` | `7` | no |
| <a name="input_kms_key_policy"></a> [kms\_key\_policy](#input\_kms\_key\_policy) | Specifies a custom IAM policy for the KMS key. This policy controls who can use and manage the KMS key.<br/>If not provided, a default policy will be used that allows:<br/>- Root account access for key administration<br/>- CodeArtifact service for encryption operations<br/>- S3 service for encryption operations<br/>- CloudWatch Logs for encryption operations<br/><br/>The policy should be provided as a JSON-encoded string and must follow AWS KMS key policy syntax and rules.<br/>See AWS documentation for KMS key policies: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html<br/><br/>**IMPORTANT SECURITY CONSIDERATIONS**:<br/>- Ensure the policy follows the principle of least privilege<br/>- Include necessary permissions for key administration<br/>- Consider including conditions for additional security<br/>- Don't remove essential service permissions needed for CodeArtifact operation<pre></pre> | `string` | `null` | no |
| <a name="input_log_group_retention_days"></a> [log\_group\_retention\_days](#input\_log\_group\_retention\_days) | Determines how long CloudWatch Logs retains log events in the specified log group. This setting helps manage storage costs while ensuring compliance with data retention requirements. The retention period can be set from 1 day to 10 years (3650 days). Common retention periods are 30 days for operational logs, 90 days for compliance, or longer for audit purposes. After the specified period, CloudWatch Logs automatically deletes expired log events. | `number` | `30` | no |
| <a name="input_s3_bucket_policy_override"></a> [s3\_bucket\_policy\_override](#input\_s3\_bucket\_policy\_override) | Optional custom bucket policy to override the default policy. This should be a valid JSON-encoded policy.<br/>When provided, this policy will completely replace the default bucket policy.<br/><br/>**IMPORTANT NOTES**:<br/>- This policy must be a valid S3 bucket policy document<br/>- The policy must include necessary principal and resource configurations<br/>- If provided, this overrides all other policy configurations<br/><br/>**USAGE EXAMPLE**:<pre>hcl<br/>s3_bucket_policy_override = jsonencode({<br/>  Version = "2012-10-17"<br/>  Statement = [<br/>    {<br/>      Sid       = "AllowCrossAccountAccess"<br/>      Effect    = "Allow"<br/>      Principal = {<br/>        AWS = ["arn:aws:iam::ACCOUNT-ID:root"]<br/>      }<br/>      Action    = ["s3:GetObject", "s3:ListBucket"]<br/>      Resource  = ["arn:aws:s3:::BUCKET-NAME/*"]<br/>    }<br/>  ]<br/>})</pre> | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module. These tags will be applied to all resources that support tagging, helping with resource organization, cost allocation, and access control. Tags should follow your organization's tagging strategy and might include values for environment, project, owner, or other relevant categories. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_feature_flags"></a> [feature\_flags](#output\_feature\_flags) | The feature flags set for the module. |
| <a name="output_is_enabled"></a> [is\_enabled](#output\_is\_enabled) | Whether the module is enabled or not. |
| <a name="output_kms_key_alias_arn"></a> [kms\_key\_alias\_arn](#output\_kms\_key\_alias\_arn) | The ARN of the KMS key alias |
| <a name="output_kms_key_alias_name"></a> [kms\_key\_alias\_name](#output\_kms\_key\_alias\_name) | The name of the KMS key alias |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ID of the KMS key used for encryption |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch Log Group |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch Log Group |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The domain name of the S3 bucket |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the S3 bucket |
| <a name="output_s3_bucket_regional_domain_name"></a> [s3\_bucket\_regional\_domain\_name](#output\_s3\_bucket\_regional\_domain\_name) | The regional domain name of the S3 bucket |
| <a name="output_tags_set"></a> [tags\_set](#output\_tags\_set) | The tags set for the module. |
<!-- END_TF_DOCS -->