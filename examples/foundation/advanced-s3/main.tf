###################################
# Example Data Sources 📊
###################################

data "aws_caller_identity" "current" {
  provider = aws.source
}

###################################
# Foundation Module Call (Replica Bucket) 🚀 (Using Replica Region Provider)
# ----------------------------------------------------
# Create the replica bucket using the foundation module itself,
# but without enabling replication *on* the replica.
###################################
module "replica_foundation" {
  source = "../../../modules/foundation"

  providers = {
    aws = aws.replica # Explicitly use the replica provider
  }

  # --- Feature Flags ---
  is_enabled                = var.is_enabled # Use example's master flag
  is_s3_bucket_enabled      = true           # Must be enabled to create the bucket
  is_kms_key_enabled        = false          # Disable KMS for replica for simplicity
  is_log_group_enabled      = false          # Disable Logs for replica for simplicity
  is_oidc_provider_enabled  = false          # Disable OIDC for replica
  is_s3_replication_enabled = false          # IMPORTANT: Replication is NOT enabled on the replica itself

  # --- S3 Bucket Configuration ---
  # Use a unique name for the replica bucket
  s3_bucket_name = "${var.replica_bucket_name}-${data.aws_caller_identity.current.account_id}-${var.replica_region}"

  # --- Other Foundation Inputs (using example vars/defaults or specific replica values) ---
  # Provide dummy values for required inputs of disabled features if necessary,
  # though module defaults should handle nulls when features are disabled.
  kms_key_alias            = "alias/replica-${var.kms_key_alias}"      # Needs unique alias if enabled
  log_group_name           = "${var.log_group_name}-replica"           # Needs unique name if enabled
  codeartifact_domain_name = "${var.codeartifact_domain_name}-replica" # Naming consistency

  # Common Tags
  tags = merge(
    var.tags,
    { Name = "${var.replica_bucket_name}-${data.aws_caller_identity.current.account_id}-${var.replica_region}" }
  )
}


###################################
# IAM Role & Policy for Replication 📜 (Created in Source Region)
# ----------------------------------------------------
# IAM resources needed by S3 to perform replication.
# These are typically created in the source region.
###################################

data "aws_iam_policy_document" "assume_role" {
  count    = var.is_enabled ? 1 : 0
  provider = aws.source

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    # Optional: Condition to restrict role assumption to specific source bucket/account
    # condition {
    #   test     = "ArnLike"
    #   variable = "aws:SourceArn"
    #   values   = [module.this.s3_bucket_arn] # Reference source bucket ARN from module output
    # }
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:SourceAccount"
    #   values   = [data.aws_caller_identity.current.account_id]
    # }
  }
}

resource "aws_iam_role" "replication" {
  count    = var.is_enabled ? 1 : 0
  provider = aws.source # Role created in the source region

  name               = var.replication_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json # Add index [0]
  tags = merge(
    var.tags,
    { Name = var.replication_role_name }
  )
}

data "aws_iam_policy_document" "replication" {
  count    = var.is_enabled ? 1 : 0
  provider = aws.source

  # Policy based on AWS documentation for S3 replication
  # Source Bucket Permissions
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    # Reference source bucket ARN from module output
    resources = [module.this.s3_bucket_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["${module.this.s3_bucket_arn}/*"]
  }

  # Destination Bucket Permissions
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    # Reference replica bucket ARN from replica module output
    resources = ["${module.replica_foundation.s3_bucket_arn}/*"]
  }

  # KMS Permissions (if destination bucket uses KMS - requires enabling KMS in replica_foundation)
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "kms:Encrypt"
  #   ]
  #   # Add ARN of the KMS key used by the destination bucket
  #   resources = [module.replica_foundation.kms_key_arn]
  # }
}

resource "aws_iam_policy" "replication" {
  count    = var.is_enabled ? 1 : 0
  provider = aws.source # Policy created in the source region

  name   = "${var.replication_role_name}-policy"
  policy = data.aws_iam_policy_document.replication[0].json # Add index [0]
  tags = merge(
    var.tags,
    { Name = "${var.replication_role_name}-policy" }
  )
}

resource "aws_iam_role_policy_attachment" "replication" {
  count    = var.is_enabled ? 1 : 0
  provider = aws.source # Attachment in the source region

  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn # Add index [0]
}


###################################
# Foundation Module Call (Source Bucket) 🚀 (Using Source Region Provider)
###################################

module "this" {
  source = "../../../modules/foundation"

  providers = {
    aws = aws.source # Explicitly use the source provider for foundation resources
  }

  # --- Feature Flags ---
  is_enabled           = var.is_enabled
  is_kms_key_enabled   = var.is_kms_key_enabled   # Disabled by default in this example's vars
  is_log_group_enabled = var.is_log_group_enabled # Disabled by default in this example's vars
  is_s3_bucket_enabled = var.is_s3_bucket_enabled # Enabled by default in this example's vars

  # --- S3 Bucket Configuration ---
  s3_bucket_name = var.source_bucket_name # Use variable defined for this example

  # --- S3 Replication Configuration ---
  is_s3_replication_enabled = var.is_enabled
  s3_replication_role_arn   = var.is_enabled ? aws_iam_role.replication[0].arn : null # Pass null if disabled or replication off
  s3_replication_destination = var.is_enabled ? {                                     # Pass null if disabled or replication off
    # Reference replica bucket ARN from replica module output
    bucket_arn = module.replica_foundation.s3_bucket_arn
    # storage_class = "STANDARD_IA" # Optional: specify replica storage class
  } : null

  # --- Other Foundation Inputs (using example vars/defaults) ---
  kms_key_alias            = var.kms_key_alias            # Required by module if KMS enabled
  log_group_name           = var.log_group_name           # Required by module if Logs enabled
  codeartifact_domain_name = var.codeartifact_domain_name # Used for naming consistency

  # OIDC is disabled by default in this example's variables
  is_oidc_provider_enabled = var.is_oidc_provider_enabled

  # Common Tags
  tags = var.tags

  # Explicit dependency to ensure replica bucket exists before source replication is configured
  depends_on = [module.replica_foundation]
}
