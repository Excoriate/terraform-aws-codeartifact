locals {
  ###################################
  # Feature Flags ⛳️
  # ----------------------------------------------------
  #
  # These flags are used to enable or disable certain features.
  # 1. `is_enabled` - Master toggle for all resources in this module
  # 2. `is_kms_key_enabled` - Flag to control KMS key creation
  # 3. `is_log_group_enabled` - Flag to control CloudWatch Log Group creation
  # 4. `is_s3_bucket_enabled` - Flag to control S3 bucket creation
  #
  ###################################
  is_enabled                = var.is_enabled
  is_kms_key_enabled        = local.is_enabled && var.is_kms_key_enabled
  is_log_group_enabled      = local.is_enabled && var.is_log_group_enabled
  is_s3_bucket_enabled      = local.is_enabled && var.is_s3_bucket_enabled
  is_oidc_provider_enabled  = local.is_enabled && var.is_oidc_provider_enabled
  is_oidc_existing_provider = local.is_oidc_provider_enabled && var.oidc_use_existing_provider

  ###################################
  # Resource Naming 🏷️
  # ----------------------------------------------------
  #
  # Standardized naming for resources created by this module
  #
  ###################################
  # CodeArtifact domain name for resource naming
  codeartifact_domain_name = var.codeartifact_domain_name

  # KMS key naming and description
  kms_key_description = "KMS key for CodeArtifact ${local.codeartifact_domain_name} domain encryption and backup"
  kms_key_policy = coalesce(var.kms_key_policy, jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable Limited IAM Root User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CodeArtifact Service Encryption Operations"
        Effect = "Allow"
        Principal = {
          Service = "codeartifact.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow S3 Service Encryption Operations"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs Encryption"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  }))

  ###################################
  # Tags 🏷️
  # ----------------------------------------------------
  #
  # Common tags to be applied to all resources
  #
  ###################################
  common_tags = merge(
    var.tags,
    {
      "Module"    = "terraform-aws-codeartifact-foundation"
      "ManagedBy" = "terraform"
    }
  )

  # S3 bucket name configuration with domain name integration
  bucket_name = var.bucket_name != null ? var.bucket_name : "codeartifact-${local.codeartifact_domain_name}-${data.aws_caller_identity.current.account_id}"

  # S3 bucket policy configuration
  default_bucket_policy_statement = {
    sid     = "AllowDefaultAccess"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    principals = {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }

  # Combine default and additional policies if no override is provided
  bucket_policy_statements = var.s3_bucket_policy_override == null ? concat(
    [local.default_bucket_policy_statement],
    var.additional_bucket_policies
  ) : null

  # Generate the final bucket policy
  bucket_policy = var.s3_bucket_policy_override != null ? var.s3_bucket_policy_override : jsonencode({
    Version = "2012-10-17"
    Statement = [
      for statement in local.bucket_policy_statements : merge(
        {
          Sid       = statement.sid
          Effect    = statement.effect
          Principal = statement.principals
          Action    = statement.actions
          Resource  = statement.resources
        },
        # Only include Condition if it exists in the statement
        try({ Condition = statement.condition }, {})
      )
    ]
  })

  # Default CloudWatch log group name using the domain name
  default_log_group_name = "/aws/codeartifact/${local.codeartifact_domain_name}/audit-logs"

  # Feature flags for bucket policy
  is_bucket_policy_enabled = var.is_enabled && (var.s3_bucket_policy_override != null || length(var.additional_bucket_policies) > 0)

  ###################################
  # OIDC Locals 🔑
  # ----------------------------------------------------
  #
  # Locals related to OIDC provider configuration
  #
  ###################################
  # Determine the final thumbprint list: use provided list if not empty, otherwise attempt to use the fetched one.
  # Only relevant when creating the provider (var.oidc_use_existing_provider is false).
  # Defaults to empty list if OIDC is disabled, using existing, or fetching fails/is not attempted.
  oidc_thumbprint_list_final = local.is_oidc_provider_enabled && !var.oidc_use_existing_provider ? (
    length(var.oidc_thumbprint_list) > 0 ? var.oidc_thumbprint_list : try(
      # Access data source only if its count is > 0
      [data.tls_certificate.oidc[0].certificates[0].sha1_fingerprint],
      # Default to empty list if data source wasn't run or failed
      []
    )
  ) : []

  # Determine the OIDC provider ARN based on whether we created it or used an existing one
  oidc_provider_arn = local.is_oidc_provider_enabled ? (
    var.oidc_use_existing_provider ?
    try(data.aws_iam_openid_connect_provider.existing[0].arn, null) : # Get ARN from data source
    try(resource.aws_iam_openid_connect_provider.oidc[0].arn, null)   # Get ARN from created resource
  ) : null

  # Flattened list for creating managed policy attachments for OIDC roles
  oidc_managed_policy_attachments = local.is_oidc_provider_enabled ? flatten([
    for role in var.oidc_roles : [
      for policy_arn in role.attach_policy_arns : {
        role_name  = role.name
        policy_arn = policy_arn
      }
    ]
  ]) : []

  # Flattened list for creating inline policies for OIDC roles
  oidc_inline_policy_definitions = local.is_oidc_provider_enabled ? flatten([
    for role in var.oidc_roles : [
      for policy_name, policy_json in role.inline_policies : {
        role_name   = role.name
        policy_name = policy_name
        policy_json = policy_json
      }
    ]
  ]) : []
}
