resource "aws_codeartifact_domain" "this" {
  count = local.create_domain ? 1 : 0

  domain         = local.domain_name
  encryption_key = var.kms_key_arn

  # AWS will use the default aws/codeartifact key if no encryption_key is provided
  # The API doesn't require an encryption_key parameter, so we don't need to conditionally include it

  tags = local.tags
}

resource "aws_codeartifact_domain_permissions_policy" "this" {
  count = local.create_domain_permissions_policy ? 1 : 0

  domain          = aws_codeartifact_domain.this[0].domain
  domain_owner    = local.effective_domain_owner
  policy_document = local.domain_permissions_policy

  # IMPORTANT: This resource depends on the domain resource being created first
  depends_on = [aws_codeartifact_domain.this]
}
