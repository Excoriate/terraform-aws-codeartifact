resource "aws_codeartifact_repository" "this" {
  count = local.create_repository ? 1 : 0

  domain      = var.domain_name
  repository  = var.repository_name
  description = var.description # Will be null if var.description is null
  tags        = local.tags

  dynamic "upstream" {
    # Iterate over the upstreams list only if it's not null and not empty.
    # Using var.upstreams directly handles both null and empty list cases correctly in TF 1.0+.
    for_each = var.upstreams == null ? [] : var.upstreams
    content {
      repository_name = upstream.value.repository_name
    }
  }

  dynamic "external_connections" {
    # Iterate over the external_connections list only if it's not null and not empty.
    # Convert to set for dynamic block compatibility if needed, though list should work.
    for_each = var.external_connections == null ? [] : var.external_connections
    content {
      external_connection_name = external_connections.value
    }
  }
}

resource "aws_codeartifact_repository_permissions_policy" "this" {
  count = local.create_policy ? 1 : 0

  domain          = var.domain_name
  repository      = aws_codeartifact_repository.this[0].repository
  policy_document = var.repository_policy_document
}
