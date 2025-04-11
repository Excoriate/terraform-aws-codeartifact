###################################
# Example Data Sources 📊
###################################

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

###################################
# Replica Bucket Resources 🪣 (Created in Replica Region)
# ----------------------------------------------------
# These resources are created directly by the example
# to provide the destination for replication.
###################################

resource "aws_s3_bucket" "replica" {
  provider = aws.replica # Use the replica provider

  # Ensure unique bucket name, potentially incorporating region or account ID
  bucket = "${var.replica_bucket_name}-${data.aws_caller_identity.current.account_id}-${var.replica_region}"

  tags = merge(
    var.tags,
    { Name = var.replica_bucket_name }
  )
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.replica # Use the replica provider

  bucket = aws_s3_bucket.replica.id
  versioning_configuration {
    status = "Enabled" # Replication requires versioning on destination
  }
}

###################################
# IAM Role & Policy for Replication 📜 (Created in Source Region)
# ----------------------------------------------------
# IAM resources needed by S3 to perform replication.
# These are typically created in the source region.
###################################

data "aws_iam_policy_document" "assume_role" {
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
    #   values   = ["arn:${data.aws_partition.current.partition}:s3:::${var.source_bucket_name}"]
    # }
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:SourceAccount"
    #   values   = [data.aws_caller_identity.current.account_id]
    # }
  }
}

resource "aws_iam_role" "replication" {
  provider = aws.source # Role created in the source region

  name               = var.replication_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(
    var.tags,
    { Name = var.replication_role_name }
  )
}

data "aws_iam_policy_document" "replication" {
  # Policy based on AWS documentation for S3 replication
  # Source Bucket Permissions
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    # Use module output for source bucket ARN once available
    # For now, construct it, assuming module call succeeds
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.source_bucket_name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["arn:${data.aws_partition.current.partition}:s3:::${var.source_bucket_name}/*"]
  }

  # Destination Bucket Permissions
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = ["${aws_s3_bucket.replica.arn}/*"]
  }

  # KMS Permissions (if destination bucket uses KMS)
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "kms:Encrypt"
  #   ]
  #   # Add ARN of the KMS key used by the destination bucket
  #   resources = ["arn:aws:kms:${var.replica_region}:${data.aws_caller_identity.current.account_id}:key/your-replica-kms-key-id"]
  # }
}

resource "aws_iam_policy" "replication" {
  provider = aws.source # Policy created in the source region

  name   = "${var.replication_role_name}-policy"
  policy = data.aws_iam_policy_document.replication.json
  tags = merge(
    var.tags,
    { Name = "${var.replication_role_name}-policy" }
  )
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider = aws.source # Attachment in the source region

  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


###################################
# Foundation Module Call 🚀 (Using Source Region Provider)
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
  is_s3_replication_enabled = var.is_replication_enabled # Controlled by fixture
  s3_replication_role_arn   = aws_iam_role.replication.arn
  s3_replication_destination = {
    bucket_arn = aws_s3_bucket.replica.arn
    # storage_class = "STANDARD_IA" # Optional: specify replica storage class
  }

  # --- Other Foundation Inputs (using example vars/defaults) ---
  kms_key_alias            = var.kms_key_alias            # Required by module if KMS enabled
  log_group_name           = var.log_group_name           # Required by module if Logs enabled
  codeartifact_domain_name = var.codeartifact_domain_name # Used for naming consistency

  # OIDC is disabled by default in this example's variables
  is_oidc_provider_enabled = var.is_oidc_provider_enabled

  # Common Tags
  tags = var.tags
}
