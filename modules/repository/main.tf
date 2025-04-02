resource "aws_codeartifact_repository" "this" {
  count = local.create_repository ? 1 : 0

  domain      = var.domain_name
  repository  = var.repository_name
  description = var.description # Will be null if var.description is null
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = var.upstreams == null || var.external_connection == null
      error_message = "A CodeArtifact repository cannot have both 'upstreams' and 'external_connection' configured simultaneously. Please provide only one or neither."
    }
  }

  dynamic "upstream" {
    # Iterate over the upstreams list only if it's not null and not empty.
    # Using var.upstreams directly handles both null and empty list cases correctly in TF 1.0+.
    for_each = var.upstreams == null ? [] : var.upstreams
    content {
      repository_name = upstream.value.repository_name
    }
  }

  dynamic "external_connections" {
    # Iterate over a list containing zero or one element, based on the string variable.
    for_each = var.external_connection == null ? [] : [var.external_connection]
    content {
      # external_connections.value is now just each.value (the connection string itself)
      external_connection_name = var.external_connection
    }
  }
}

resource "aws_codeartifact_repository_permissions_policy" "this" {
  count = local.create_policy ? 1 : 0

  domain          = var.domain_name
  repository      = aws_codeartifact_repository.this[0].repository
  policy_document = var.repository_policy_document
}
