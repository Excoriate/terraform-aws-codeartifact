locals {
  # Flag to enable/disable the entire module
  is_enabled = var.is_enabled

  # Determine effective owner (current account or specified)
  effective_domain_owner = coalesce(var.domain_owner, data.aws_caller_identity.current.account_id)

  # Construct the domain ARN needed for policy statements
  domain_arn = "arn:${data.aws_partition.current.partition}:codeartifact:${data.aws_region.current.name}:${local.effective_domain_owner}:domain/${var.domain_name}"

  # --- Policy Construction Logic ---

  # Flag to determine if the policy resource should be created.
  # The policy will be created if the module is enabled (local.is_enabled is true)
  # and at least one of the following conditions is met:
  # 1. A policy document override is provided (var.policy_document_override is not null).
  # 2. There are read principals specified (length(var.read_principals) > 0).
  # 3. There are list repository principals specified (length(var.list_repo_principals) > 0).
  # 4. There are authorization token principals specified (length(var.authorization_token_principals) > 0).
  # 5. There are custom policy statements provided (length(var.custom_policy_statements) > 0).
  create_policy = local.is_enabled && (
    var.policy_document_override != null ||
    length(var.read_principals) > 0 ||
    length(var.list_repo_principals) > 0 ||
    length(var.authorization_token_principals) > 0 ||
    length(var.custom_policy_statements) > 0
  )

  # Flag to determine if the combined policy document data source should be evaluated.
  # Only needed if we are creating a policy AND no override is provided.
  create_combined_policy_doc = local.create_policy && var.policy_document_override == null

  # Determine the final policy document content.
  # Use the override if provided, otherwise use the dynamically generated one (if it was created).
  final_policy_document = local.create_policy ? (
    var.policy_document_override != null ? var.policy_document_override : try(data.aws_iam_policy_document.combined[0].json, null)
  ) : null
}
