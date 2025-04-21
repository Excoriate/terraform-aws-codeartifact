###################################
# Module Resources 🛠️
# ----------------------------------------------------
#
# This section declares the resources that will be created or managed by this Terraform module.
# Each resource is annotated with comments explaining its purpose and any notable configurations.
#
###################################

###################################
# KMS Key for Encryption 🔐
# ----------------------------------------------------
#
# KMS key used for encrypting CodeArtifact artifacts
# and S3 bucket objects
#
###################################
resource "aws_kms_key" "this" {
  count = local.is_kms_key_enabled ? 1 : 0

  description             = local.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  policy                  = local.kms_key_policy

  tags = local.common_tags
}

resource "aws_kms_alias" "this" {
  count = local.is_kms_key_enabled ? 1 : 0

  name          = var.kms_key_alias
  target_key_id = aws_kms_key.this[0].key_id
}

###################################
# CloudWatch Log Group 📝
# ----------------------------------------------------
#
# Log group for CodeArtifact audit logs
#
###################################
resource "aws_cloudwatch_log_group" "this" {
  count = local.is_log_group_enabled ? 1 : 0

  name              = coalesce(var.log_group_name, local.default_log_group_name)
  retention_in_days = var.log_group_retention_days
  kms_key_id        = local.is_kms_key_enabled ? aws_kms_key.this[0].arn : null

  tags = merge(
    local.common_tags,
    {
      Name       = coalesce(var.log_group_name, local.default_log_group_name)
      DomainName = local.codeartifact_domain_name
    }
  )
}

###################################
# S3 Bucket for Backup/Migration 🪣
# ----------------------------------------------------
#
# S3 bucket for storing CodeArtifact backups and
# migration artifacts
#
###################################
resource "aws_s3_bucket" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket        = var.s3_bucket_name
  force_destroy = var.force_destroy_bucket

  tags = merge(
    local.common_tags,
    {
      Name       = var.s3_bucket_name
      DomainName = local.codeartifact_domain_name
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.is_kms_key_enabled ? aws_kms_key.this[0].arn : null
      sse_algorithm     = local.is_kms_key_enabled ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = local.is_s3_bucket_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count = local.is_bucket_policy_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = local.bucket_policy
}

###################################
# S3 Bucket Replication Configuration 🔄
# ----------------------------------------------------
#
# Optional configuration for replicating S3 bucket contents
# to another bucket.
#
###################################
resource "aws_s3_bucket_replication_configuration" "this" {
  count = local.is_replication_configuration_enabled ? 1 : 0

  depends_on = [aws_s3_bucket_versioning.this] # Ensure versioning is applied first

  role   = var.s3_replication_role_arn
  bucket = aws_s3_bucket.this[0].id

  rule {
    id     = "default-replication-rule" # Simple ID for the single rule allowed by the module currently
    status = "Enabled"

    # Use an empty filter block for V2 config to replicate all objects
    # To filter, the caller would need to manage this resource outside the module
    # or the module inputs would need to be significantly more complex.
    filter {}

    destination {
      bucket        = var.s3_replication_destination.bucket_arn
      storage_class = var.s3_replication_destination.storage_class
      # Add other destination options like metrics, encryption_configuration if needed in future enhancements
    }
    delete_marker_replication {
      // TODO: Maybe offer this as part of the module's interface
      status = "Enabled"
    }

    # Add source_selection_criteria if needed in future enhancements
  }
}

###################################
# OIDC Provider and Roles 🔑
# ----------------------------------------------------
#
# Creates an IAM OIDC provider and associated roles
# for federated access from CI/CD systems like
# GitLab or GitHub Actions.
#
###################################

resource "aws_iam_openid_connect_provider" "oidc" {
  # Create provider only if OIDC is enabled AND we are not using an existing one
  count = local.is_oidc_provider_enabled && !var.oidc_use_existing_provider ? 1 : 0

  url             = var.oidc_provider_url
  client_id_list  = var.oidc_client_id_list
  thumbprint_list = local.oidc_thumbprint_list_final # Uses fetched thumbprint if var.oidc_thumbprint_list is empty

  tags = merge(
    local.common_tags,
    { Name = "${var.oidc_provider_url}-provider" } # Simple name tag
  )
}

resource "aws_iam_role" "oidc" {
  # Create one role for each entry in var.oidc_roles if OIDC is enabled
  for_each = local.is_oidc_provider_enabled ? { for role in var.oidc_roles : role.name => role } : {}

  name                 = each.value.name
  description          = each.value.description
  assume_role_policy   = data.aws_iam_policy_document.oidc_assume_role[each.key].json # Use the specific policy doc for this role
  max_session_duration = each.value.max_session_duration
  tags = merge(
    local.common_tags,
    { Name = each.value.name }
  )

  # Ensure OIDC provider exists (either created or data source read) before creating the roles that trust it
  depends_on = [aws_iam_openid_connect_provider.oidc, data.aws_iam_openid_connect_provider.existing]
}

resource "aws_iam_role_policy_attachment" "oidc" {
  # Create attachments based on the flattened local variable
  for_each = { for attachment in local.oidc_managed_policy_attachments : "${attachment.role_name}/${attachment.policy_arn}" => attachment }

  role       = aws_iam_role.oidc[each.value.role_name].name # Reference the role created in the loop above
  policy_arn = each.value.policy_arn

  # Ensure the specific role exists before attaching policies
  depends_on = [aws_iam_role.oidc]
}

resource "aws_iam_role_policy" "oidc_inline" {
  # Create inline policies based on the flattened local variable
  for_each = { for policy in local.oidc_inline_policy_definitions : "${policy.role_name}/${policy.policy_name}" => policy }

  name   = each.value.policy_name
  role   = aws_iam_role.oidc[each.value.role_name].id # Reference the role created in the loop above
  policy = each.value.policy_json

  # Ensure the specific role exists before attaching policies
  depends_on = [aws_iam_role.oidc]
}
