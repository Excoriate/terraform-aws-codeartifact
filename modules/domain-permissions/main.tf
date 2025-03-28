resource "aws_codeartifact_domain_permissions_policy" "this" {
  # Use the create_policy flag defined in locals.tf
  count = local.create_policy ? 1 : 0

  domain       = var.domain_name
  domain_owner = local.effective_domain_owner
  # Use the final policy document from locals, which handles the override logic
  policy_document = local.final_policy_document
  policy_revision = var.policy_revision
}
