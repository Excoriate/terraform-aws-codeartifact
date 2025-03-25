resource "aws_codeartifact_domain_permissions_policy" "this" {
  count = local.create_domain_permissions ? 1 : 0

  domain          = var.domain_name
  domain_owner    = local.effective_domain_owner
  policy_document = var.policy_document
  policy_revision = var.policy_revision
}
