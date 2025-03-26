locals {
  # Flag to enable/disable the entire module
  is_enabled = var.is_enabled

  # Determine effective owner (current account or specified)
  effective_domain_owner = coalesce(var.domain_owner, data.aws_caller_identity.current.account_id)

  # Construct the domain ARN needed for policy statements
  domain_arn = "arn:${data.aws_partition.current.partition}:codeartifact:${data.aws_region.current.name}:${local.effective_domain_owner}:domain/${var.domain_name}"

  # --- Policy Construction Logic ---

  # Flag to determine if the policy resource should be created.
  # Create if module is enabled AND (an override is provided OR any baseline/custom inputs are provided)
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
