# Replication Enabled fixture: Enables S3 replication in the foundation module.
# Provides necessary configuration for cross-region replication setup.

# --- Feature Flags ---
is_enabled              = true
is_s3_bucket_enabled    = true  # Must be true for replication
is_replication_enabled = true  # Enable the replication feature

# --- Region Configuration ---
source_region  = "us-east-1"
replica_region = "eu-west-1"

# --- Naming Configuration ---
# Using unique names to avoid conflicts during testing
source_bucket_name    = "foundation-adv-s3-src-fixt-unique"
replica_bucket_name   = "foundation-adv-s3-rep-fixt-unique"
replication_role_name = "foundation-adv-s3-repl-role-fixt"

# --- Tags ---
tags = {
  Environment = "fixture-test"
  Project     = "foundation-advanced-s3-enabled"
  ManagedBy   = "terraform"
}

# --- Optional: Override other foundation module defaults if needed for this test case ---
# e.g., kms_key_alias = "alias/my-replication-test-key"
# e.g., log_group_name = "/aws/codeartifact/replication-test-logs"
# By default, KMS and Logs features are disabled via variables.tf in this example.
