resource "aws_codeartifact_repository_permissions_policy" "this" {
  # Create the policy only if the module is enabled
  count = local.create_policy ? 1 : 0

  domain          = var.domain_name
  repository      = var.repository_name
  domain_owner    = local.effective_domain_owner # Uses default (current account) if var.domain_owner is null
  policy_revision = var.policy_revision          # Pass-through for optimistic locking

  # Use the JSON output from the combined policy document data source
  # Access with [0] because the data source uses count = var.is_enabled ? 1 : 0
  policy_document = data.aws_iam_policy_document.combined[0].json
}
