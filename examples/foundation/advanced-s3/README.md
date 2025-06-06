# Advanced S3 Example: AWS CodeArtifact Foundation Module

## Overview
> **Note:** This example demonstrates using the S3 replication feature within the `foundation` module found in `modules/foundation`. It sets up a source bucket via the module and a replica bucket directly, along with the necessary IAM role, to showcase cross-region replication.

### 🔑 Key Features Demonstrated
- Enabling `is_s3_replication_enabled` in the foundation module.
- Providing `s3_replication_role_arn` and `s3_replication_destination` to the module.
- Creating the replica S3 bucket (with versioning) in a different region using a provider alias.
- Creating the required IAM Role and Policy for S3 replication.
- Using fixtures (`fixtures/*.tfvars`) to test replication enabled/disabled scenarios.

### 📋 Usage Guidelines
1.  **Configure:** Use the `fixtures/replication-enabled.tfvars` file as a template. Customize the `source_region`, `replica_region`, `source_bucket_name`, `replica_bucket_name`, and `replication_role_name`. Ensure the specified regions exist and your AWS credentials have permissions in both.
    ```tfvars
    # fixtures/replication-enabled.tfvars (Example Structure)
    source_region           = "us-east-1"
    replica_region          = "eu-west-1"
    source_bucket_name      = "my-foundation-source-bucket-unique"
    replica_bucket_name     = "my-foundation-replica-bucket-unique"
    replication_role_name   = "MyS3ReplicationRole"
    is_replication_enabled  = true
    # other vars...
    ```
2.  **Initialize:** Run `terraform init`.
3.  **Plan:** Run `terraform plan -var-file=fixtures/replication-enabled.tfvars`. Review the plan to ensure resources are created in the correct regions.
4.  **Apply:** Run `terraform apply -var-file=fixtures/replication-enabled.tfvars`.
5.  **Makefile:** Alternatively, use the provided `Makefile` targets (e.g., `make plan-replication-enabled`, `make apply-replication-enabled`).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
