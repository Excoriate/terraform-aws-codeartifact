data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

// Construct the combined policy document from baseline principals and custom statements
data "aws_iam_policy_document" "combined" {
  # Only generate the combined document if the module is enabled AND no override is provided.
  count = var.policy_document_override == null && var.is_enabled ? 1 : 0

  # Default statement: Ensure the policy is never empty and owner can always read the policy.
  # This helps prevent "ValidationException: Policy document isn't a valid policy document"
  # when only minimal or potentially insufficient permissions are specified via variables.
  statement {
    sid    = "DefaultOwnerReadDomainPolicy"
    effect = "Allow"
    actions = [
      "codeartifact:GetDomainPermissionsPolicy",
      "codeartifact:ListRepositoriesInDomain" # Add a functional permission
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"] # Grant to the account root executing Terraform
    }
    resources = [local.domain_arn]
  }

  # Baseline: Read Domain Policy Principals
  # This statement allows specified AWS principals to read the domain permissions policy.
  dynamic "statement" {
    for_each = local.read_principals_length > 0 ? [1] : []
    content {
      sid    = "BaselineReadDomainPolicy"
      effect = "Allow"
      actions = [
        "codeartifact:GetDomainPermissionsPolicy"
      ]
      principals {
        type        = "AWS"
        identifiers = var.read_principals
      }
      resources = [local.domain_arn] // Action applies to the domain ARN
    }
  }

  // Baseline: List Repositories Principals
  // This statement allows specified AWS principals to list repositories within the domain.
  dynamic "statement" {
    for_each = local.list_repo_principals_length > 0 ? [1] : []
    content {
      sid    = "BaselineListRepositories"
      effect = "Allow"
      actions = [
        "codeartifact:ListRepositoriesInDomain"
      ]
      principals {
        type        = "AWS"
        identifiers = var.list_repo_principals
      }
      resources = [local.domain_arn] // Action applies to the domain ARN
    }
  }

  // Baseline: Get Authorization Token Principals
  // This statement allows specified AWS principals to obtain an authorization token and requires a companion action.
  dynamic "statement" {
    for_each = local.auth_token_principals_length > 0 ? [1] : []
    content {
      sid    = "BaselineGetAuthToken"
      effect = "Allow"
      actions = [
        "codeartifact:GetAuthorizationToken",
        "sts:GetServiceBearerToken" // Required companion action
      ]
      principals {
        type        = "AWS"
        identifiers = var.authorization_token_principals
      }
      resources = ["*"] // These actions require "*" resource in domain policy
    }
  }

  // Custom Policy Statements (merged in)
  // This section allows for the inclusion of custom policy statements defined by the user.
  dynamic "statement" {
    for_each = var.custom_policy_statements != null ? var.custom_policy_statements : []
    content {
      sid       = lookup(statement.value, "Sid", null)
      effect    = lookup(statement.value, "Effect", null)
      actions   = lookup(statement.value, "Action", null)
      resources = lookup(statement.value, "Resource", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "Principal", null) != null ? [lookup(statement.value, "Principal", {})] : []
        content {
          type        = lookup(principals.value, "Type", null)
          identifiers = lookup(principals.value, "Identifiers", null)
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "Condition", null) != null ? [lookup(statement.value, "Condition", {})] : []
        content {
          test     = condition.value.Test
          variable = condition.value.Variable
          values   = condition.value.Values
        }
      }
    }
  }
}
