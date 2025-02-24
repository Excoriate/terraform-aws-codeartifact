## Resource: aws\_s3\_bucket

Provides a S3 bucket resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#example-usage)

### [Private Bucket With Tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#private-bucket-with-tags)

```terraform
resource "aws_s3_bucket" "example" { bucket = "my-tf-test-bucket" tags = { Name = "My bucket" Environment = "Dev" } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#argument-reference)

This resource supports the following arguments:

-   [`bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket-1) - (Optional, Forces new resource) Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. A full list of bucket naming rules [may be found here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html). The name must not be in the format `[bucket_name]--[azid]--x-s3`. Use the [`aws_s3_directory_bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_directory_bucket) resource to manage S3 Express buckets.
-   [`bucket_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket_prefix-1) - (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with `bucket`. Must be lowercase and less than or equal to 37 characters in length. A full list of bucket naming rules [may be found here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).
-   [`force_destroy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#force_destroy-1) - (Optional, Default:`false`) Boolean that indicates all objects (including any [locked objects](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html)) should be deleted from the bucket _when the bucket is destroyed_ so that the bucket can be destroyed without error. These objects are _not_ recoverable. This only deletes objects when the bucket is destroyed, _not_ when setting this parameter to `true`. Once this parameter is set to `true`, there must be a successful `terraform apply` run before a destroy is required to update this value in the resource state. Without a successful `terraform apply` after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful `terraform apply` is required to set this value in state before it will take effect on a destroy operation.
-   [`object_lock_enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object_lock_enabled-1) - (Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. Valid values are `true` or `false`. This argument is not supported in all regions or partitions.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-7) - (Optional) Map of tags to assign to the bucket. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

The following arguments are deprecated, and will be removed in a future major version:

-   [`acceleration_status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#acceleration_status-1) - (Optional, **Deprecated**) Sets the accelerate configuration of an existing bucket. Can be `Enabled` or `Suspended`. Cannot be used in `cn-north-1` or `us-gov-west-1`. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_accelerate_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) instead.
-   [`acl`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#acl-1) - (Optional, **Deprecated**) The [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) to apply. Valid values are `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, and `log-delivery-write`. Defaults to `private`. Conflicts with `grant`. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_acl`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) instead.
-   [`grant`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#grant-1) - (Optional, **Deprecated**) An [ACL policy grant](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#sample-acl). See [Grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#grant) below for details. Conflicts with `acl`. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_acl`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) instead.
-   [`cors_rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#cors_rule-1) - (Optional, **Deprecated**) Rule of [Cross-Origin Resource Sharing](https://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html). See [CORS rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#cors-rule) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_cors_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) instead.
-   [`lifecycle_rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#lifecycle_rule-1) - (Optional, **Deprecated**) Configuration of [object lifecycle management](http://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html). See [Lifecycle Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#lifecycle-rule) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_lifecycle_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) instead.
-   [`logging`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#logging-1) - (Optional, **Deprecated**) Configuration of [S3 bucket logging](https://docs.aws.amazon.com/AmazonS3/latest/UG/ManagingBucketLogging.html) parameters. See [Logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#logging) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_logging`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) instead.
-   [`object_lock_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object_lock_configuration-1) - (Optional, **Deprecated**) Configuration of [S3 object locking](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock.html). See [Object Lock Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object-lock-configuration) below for details. Terraform wil only perform drift detection if a configuration value is provided. Use the `object_lock_enabled` parameter and the resource [`aws_s3_bucket_object_lock_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) instead.
-   [`policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy-8) - (Optional, **Deprecated**) Valid [bucket policy](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html) JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a `terraform plan`. In this case, please make sure you use the verbose/specific version of the policy. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) instead.
-   [`replication_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replication_configuration-1) - (Optional, **Deprecated**) Configuration of [replication configuration](http://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html). See [Replication Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replication-configuration) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_replication_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) instead.
-   [`request_payer`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#request_payer-1) - (Optional, **Deprecated**) Specifies who should bear the cost of Amazon S3 data transfer. Can be either `BucketOwner` or `Requester`. By default, the owner of the S3 bucket would incur the costs of any data transfer. See [Requester Pays Buckets](http://docs.aws.amazon.com/AmazonS3/latest/dev/RequesterPaysBuckets.html) developer guide for more information. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_request_payment_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) instead.
-   [`server_side_encryption_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#server_side_encryption_configuration-1) - (Optional, **Deprecated**) Configuration of [server-side encryption configuration](http://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html). See [Server Side Encryption Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#server-side-encryption-configuration) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_server_side_encryption_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) instead.
-   [`versioning`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning-1) - (Optional, **Deprecated**) Configuration of the [S3 bucket versioning state](https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html). See [Versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_versioning`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) instead.
-   [`website`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#website-1) - (Optional, **Deprecated**) Configuration of the [S3 bucket website](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html). See [Website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#website) below for details. Terraform will only perform drift detection if a configuration value is provided. Use the resource [`aws_s3_bucket_website_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) instead.

### [CORS Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#cors-rule)

The `cors_rule` configuration block supports the following arguments:

-   [`allowed_headers`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#allowed_headers-1) - (Optional) List of headers allowed.
-   [`allowed_methods`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#allowed_methods-1) - (Required) One or more HTTP methods that you allow the origin to execute. Can be `GET`, `PUT`, `POST`, `DELETE` or `HEAD`.
-   [`allowed_origins`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#allowed_origins-1) - (Required) One or more origins you want customers to be able to access the bucket from.
-   [`expose_headers`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expose_headers-1) - (Optional) One or more headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript `XMLHttpRequest` object).
-   [`max_age_seconds`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#max_age_seconds-1) - (Optional) Specifies time in seconds that browser can cache the response for a preflight request.

### [Grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#grant)

The `grant` configuration block supports the following arguments:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-5) - (Optional) Canonical user id to grant for. Used only when `type` is `CanonicalUser`.
-   [`type`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#type-1) - (Required) Type of grantee to apply for. Valid values are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported.
-   [`permissions`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#permissions-1) - (Required) List of permissions to apply for grantee. Valid values are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`.
-   [`uri`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#uri-1) - (Optional) Uri address to grant for. Used only when `type` is `Group`.

### [Lifecycle Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#lifecycle-rule)

The `lifecycle_rule` configuration block supports the following arguments:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-6) - (Optional) Unique identifier for the rule. Must be less than or equal to 255 characters in length.
-   [`prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#prefix-1) - (Optional) Object key prefix identifying one or more objects to which the rule applies.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-8) - (Optional) Specifies object tags key and value.
-   [`enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#enabled-1) - (Required) Specifies lifecycle rule status.
-   [`abort_incomplete_multipart_upload_days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#abort_incomplete_multipart_upload_days-1) (Optional) Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.
-   [`expiration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expiration-1) - (Optional) Specifies a period in the object's expire. See [Expiration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expiration) below for details.
-   [`transition`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#transition-1) - (Optional) Specifies a period in the object's transitions. See [Transition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#transition) below for details.
-   [`noncurrent_version_expiration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent_version_expiration-1) - (Optional) Specifies when noncurrent object versions expire. See [Noncurrent Version Expiration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent-version-expiration) below for details.
-   [`noncurrent_version_transition`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent_version_transition-1) - (Optional) Specifies when noncurrent object versions transitions. See [Noncurrent Version Transition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent-version-transition) below for details.

### [Expiration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expiration)

The `expiration` configuration block supports the following arguments:

-   [`date`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#date-1) - (Optional) Specifies the date after which you want the corresponding action to take effect.
-   [`days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#days-1) - (Optional) Specifies the number of days after object creation when the specific rule action takes effect.
-   [`expired_object_delete_marker`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#expired_object_delete_marker-1) - (Optional) On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers. This cannot be specified with Days or Date in a Lifecycle Expiration Policy.

### [Transition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#transition)

The `transition` configuration block supports the following arguments:

-   [`date`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#date-2) - (Optional) Specifies the date after which you want the corresponding action to take effect.
-   [`days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#days-2) - (Optional) Specifies the number of days after object creation when the specific rule action takes effect.
-   [`storage_class`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#storage_class-1) - (Required) Specifies the Amazon S3 [storage class](https://docs.aws.amazon.com/AmazonS3/latest/API/API_Transition.html#AmazonS3-Type-Transition-StorageClass) to which you want the object to transition.

### [Noncurrent Version Expiration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent-version-expiration)

The `noncurrent_version_expiration` configuration block supports the following arguments:

-   [`days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#days-3) - (Required) Specifies the number of days noncurrent object versions expire.

### [Noncurrent Version Transition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#noncurrent-version-transition)

The `noncurrent_version_transition` configuration supports the following arguments:

-   [`days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#days-4) - (Required) Specifies the number of days noncurrent object versions transition.
-   [`storage_class`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#storage_class-2) - (Required) Specifies the Amazon S3 [storage class](https://docs.aws.amazon.com/AmazonS3/latest/API/API_Transition.html#AmazonS3-Type-Transition-StorageClass) to which you want the object to transition.

### [Logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#logging)

The `logging` configuration block supports the following arguments:

-   [`target_bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#target_bucket-1) - (Required) Name of the bucket that will receive the log objects.
-   [`target_prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#target_prefix-1) - (Optional) To specify a key prefix for log objects.

### [Object Lock Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object-lock-configuration)

The `object_lock_configuration` configuration block supports the following arguments:

-   [`object_lock_enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#object_lock_enabled-2) - (Optional, **Deprecated**) Indicates whether this bucket has an Object Lock configuration enabled. Valid value is `Enabled`. Use the top-level argument `object_lock_enabled` instead.
-   [`rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule-1) - (Optional) Object Lock rule in place for this bucket ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule)).

#### Rule

The `rule` configuration block supports the following argument:

-   [`default_retention`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#default_retention-1) - (Required) Default retention period that you want to apply to new objects placed in this bucket ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#default-retention)).

#### Default Retention

The `default_retention` configuration block supports the following arguments:

-   [`mode`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#mode-1) - (Required) Default Object Lock retention mode you want to apply to new objects placed in this bucket. Valid values are `GOVERNANCE` and `COMPLIANCE`.
-   [`days`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#days-5) - (Optional) Number of days that you want to specify for the default retention period.
-   [`years`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#years-1) - (Optional) Number of years that you want to specify for the default retention period.

### [Replication Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replication-configuration)

The `replication_configuration` configuration block supports the following arguments:

-   [`role`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#role-4) - (Required) ARN of the IAM role for Amazon S3 to assume when replicating the objects.
-   [`rules`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rules-1) - (Required) Specifies the rules managing the replication ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rules)).

#### Rules

The `rules` configuration block supports the following arguments:

-   [`delete_marker_replication_status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#delete_marker_replication_status-1) - (Optional) Whether delete markers are replicated. The only valid value is `Enabled`. To disable, omit this argument. This argument is only valid with V2 replication configurations (i.e., when `filter` is used).
-   [`destination`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#destination-1) - (Required) Specifies the destination for the rule ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#destination)).
-   [`filter`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#filter-1) - (Optional, Conflicts with `prefix`) Filter that identifies subset of objects to which the replication rule applies ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#filter)).
-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-7) - (Optional) Unique identifier for the rule. Must be less than or equal to 255 characters in length.
-   [`prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#prefix-2) - (Optional, Conflicts with `filter`) Object keyname prefix identifying one or more objects to which the rule applies. Must be less than or equal to 1024 characters in length.
-   [`priority`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#priority-1) - (Optional) Priority associated with the rule. Priority should only be set if `filter` is configured. If not provided, defaults to `0`. Priority must be unique between multiple rules.
-   [`source_selection_criteria`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#source_selection_criteria-1) - (Optional) Specifies special object selection criteria ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#source-selection-criteria)).
-   [`status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#status-1) - (Required) Status of the rule. Either `Enabled` or `Disabled`. The rule is ignored if status is not Enabled.

#### Filter

The `filter` configuration block supports the following arguments:

-   [`prefix`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#prefix-3) - (Optional) Object keyname prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags-9) - (Optional) A map of tags that identifies subset of objects to which the rule applies. The rule applies only to objects having all the tags in its tagset.

#### Destination

The `destination` configuration block supports the following arguments:

-   [`bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket-2) - (Required) ARN of the S3 bucket where you want Amazon S3 to store replicas of the object identified by the rule.
-   [`storage_class`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#storage_class-3) - (Optional) The [storage class](https://docs.aws.amazon.com/AmazonS3/latest/API/API_Destination.html#AmazonS3-Type-Destination-StorageClass) used to store the object. By default, Amazon S3 uses the storage class of the source object to create the object replica.
-   [`replica_kms_key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replica_kms_key_id-1) - (Optional) Destination KMS encryption key ARN for SSE-KMS replication. Must be used in conjunction with `sse_kms_encrypted_objects` source selection criteria.
-   [`access_control_translation`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#access_control_translation-1) - (Optional) Specifies the overrides to use for object owners on replication ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#access_control_translation-block)). Must be used in conjunction with `account_id` owner override configuration.
-   [`account_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#account_id-1) - (Optional) Account ID to use for overriding the object owner on replication. Must be used in conjunction with `access_control_translation` override configuration.
-   [`replication_time`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replication_time-1) - (Optional) Enables S3 Replication Time Control (S3 RTC) ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#replication-time)).
-   [`metrics`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#metrics-1) - (Optional) Enables replication metrics (required for S3 RTC) ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#metrics)).

#### `access_control_translation` Block

The `access_control_translation` configuration block supports the following arguments:

-   [`owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#owner-1) - (Required) Specifies the replica ownership. For default and valid values, see [PUT bucket replication](https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutBucketReplication.html) in the Amazon S3 API Reference. The only valid value is `Destination`.

#### Replication Time

The `replication_time` configuration block supports the following arguments:

-   [`status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#status-2) - (Optional) Status of RTC. Either `Enabled` or `Disabled`.
-   [`minutes`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#minutes-1) - (Optional) Threshold within which objects are to be replicated. The only valid value is `15`.

#### Metrics

The `metrics` configuration block supports the following arguments:

-   [`status`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#status-3) - (Optional) Status of replication metrics. Either `Enabled` or `Disabled`.
-   [`minutes`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#minutes-2) - (Optional) Threshold within which objects are to be replicated. The only valid value is `15`.

#### Source Selection Criteria

The `source_selection_criteria` configuration block supports the following argument:

-   [`sse_kms_encrypted_objects`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#sse_kms_encrypted_objects-1) - (Optional) Match SSE-KMS encrypted objects ([documented below](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#sse-kms-encrypted-objects)). If specified, `replica_kms_key_id` in `destination` must be specified as well.

#### SSE KMS Encrypted Objects

The `sse_kms_encrypted_objects` configuration block supports the following argument:

-   [`enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#enabled-2) - (Required) Boolean which indicates if this criteria is enabled.

### [Server Side Encryption Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#server-side-encryption-configuration)

The `server_side_encryption_configuration` configuration block supports the following argument:

-   [`rule`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#rule-2) - (Required) Single object for server-side encryption by default configuration. (documented below)

The `rule` configuration block supports the following arguments:

-   [`apply_server_side_encryption_by_default`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#apply_server_side_encryption_by_default-1) - (Required) Single object for setting server-side encryption by default. (documented below)
-   [`bucket_key_enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket_key_enabled-1) - (Optional) Whether or not to use [Amazon S3 Bucket Keys](https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-key.html) for SSE-KMS.

The `apply_server_side_encryption_by_default` configuration block supports the following arguments:

-   [`sse_algorithm`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#sse_algorithm-1) - (Required) Server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`
-   [`kms_master_key_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#kms_master_key_id-1) - (Optional) AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default `aws/s3` AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`.

### [Versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#versioning)

The `versioning` configuration block supports the following arguments:

-   [`enabled`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#enabled-3) - (Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket.
-   [`mfa_delete`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#mfa_delete-1) - (Optional) Enable MFA delete for either `Change the versioning state of your bucket` or `Permanently delete an object version`. Default is `false`. This cannot be used to toggle this setting but is available to allow managed buckets to reflect the state in AWS

### [Website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#website)

The `website` configuration block supports the following arguments:

-   [`index_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#index_document-1) - (Required, unless using `redirect_all_requests_to`) Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders.
-   [`error_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#error_document-1) - (Optional) Absolute path to the document to return in case of a 4XX error.
-   [`redirect_all_requests_to`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#redirect_all_requests_to-1) - (Optional) Hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (`http://` or `https://`) to use when redirecting requests. The default is the protocol that is used in the original request.
-   [`routing_rules`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#routing_rules-1) - (Optional) JSON array containing [routing rules](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules.html) describing redirect behavior and when redirects are applied.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#id-8) - Name of the bucket.
-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn-6) - ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`.
-   [`bucket_domain_name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket_domain_name-1) - Bucket domain name. Will be of format `bucketname.s3.amazonaws.com`.
-   [`bucket_regional_domain_name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#bucket_regional_domain_name-1) - The bucket region-specific domain name. The bucket domain name including the region name. Please refer to the [S3 endpoints reference](https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_region) for format. Note: AWS CloudFront allows specifying an S3 region-specific endpoint when creating an S3 origin. This will prevent redirect issues from CloudFront to the S3 Origin URL. For more information, see the [Virtual Hosted-Style Requests for Other Regions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html#deprecated-global-endpoint) section in the AWS S3 User Guide.
-   [`hosted_zone_id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#hosted_zone_id-1) - [Route 53 Hosted Zone ID](https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_website_region_endpoints) for this bucket's region.
-   [`region`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#region-2) - AWS region this bucket resides in.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags_all-5) - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).
-   [`website_endpoint`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#website_endpoint-1) - (**Deprecated**) Website endpoint, if the bucket is configured with a website. If not, this will be an empty string. Use the resource [`aws_s3_bucket_website_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) instead.
-   [`website_domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#website_domain-1) - (**Deprecated**) Domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. Use the resource [`aws_s3_bucket_website_configuration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) instead.

## [Timeouts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#timeouts)

[Configuration options](https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts):

-   [`create`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#create-2) - (Default `20m`)
-   [`read`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#read-1) - (Default `20m`)
-   [`update`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#update-1) - (Default `20m`)
-   [`delete`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#delete-1) - (Default `60m`)

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import S3 bucket using the `bucket`. For example:

```terraform
import { to = aws_s3_bucket.bucket id = "bucket-name" }
```

Using `terraform import`, import S3 bucket using the `bucket`. For example:

```console
% terraform import aws_s3_bucket.bucket bucket-name
```