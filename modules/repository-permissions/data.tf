data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}


data "aws_iam_policy_document" "combined" {
  # Only generate the document if the module is enabled
  # The actual resource creation is handled by count in main.tf
  # This ensures we don't have data source errors if is_enabled is false.
  count = var.is_enabled ? 1 : 0

  # Baseline Read Principals Statement
  dynamic "statement" {
    for_each = length(var.read_principals) > 0 ? [1] : []
    content {
      sid    = "BaselineReadAccess"
      effect = "Allow"
      actions = [
        "codeartifact:ReadFromRepository",
        "codeartifact:GetPackageVersionReadme",
        "codeartifact:GetPackageVersionAssets", # Note: Consider if assets read is always desired for baseline read
        "codeartifact:ListPackageVersions",
        "codeartifact:ListPackageVersionAssets"
      ]
      principals {
        type        = "AWS"
        identifiers = var.read_principals
      }
      # Apply to the repository itself and packages within it
      resources = [
        local.repository_arn,
        "${local.repository_arn}/*"
      ]
    }
  }

  # Baseline Describe Principals Statement
  dynamic "statement" {
    for_each = length(var.describe_principals) > 0 ? [1] : []
    content {
      sid    = "BaselineDescribeAccess"
      effect = "Allow"
      actions = [
        "codeartifact:DescribeRepository",
        "codeartifact:ListPackages",
        "codeartifact:DescribePackageVersion" # Often useful alongside list/describe repo
      ]
      principals {
        type        = "AWS"
        identifiers = var.describe_principals
      }
      # Apply to the repository itself
      resources = [local.repository_arn]
    }
  }

  # Baseline Authorization Token Principals Statement
  dynamic "statement" {
    for_each = length(var.authorization_token_principals) > 0 ? [1] : []
    content {
      sid    = "BaselineGetAuthToken"
      effect = "Allow"
      actions = [
        "codeartifact:GetAuthorizationToken",
        "sts:GetServiceBearerToken" # Required action for GetAuthorizationToken
      ]
      principals {
        type        = "AWS"
        identifiers = var.authorization_token_principals
      }
      # GetAuthorizationToken applies at the domain level
      resources = [local.domain_arn]
    }
  }

  # Custom Policy Statements
  dynamic "statement" {
    for_each = var.custom_policy_statements
    content {
      sid       = lookup(statement.value, "Sid", null)
      effect    = lookup(statement.value, "Effect", null) # Required, validated in variables.tf
      actions   = lookup(statement.value, "Action", null) # Required, validated in variables.tf
      resources = lookup(statement.value, "Resource", null) # Required, validated in variables.tf

      dynamic "principals" {
        # Handle both single principal block and potentially multiple if needed later
        for_each = lookup(statement.value, "Principal", null) != null ? [lookup(statement.value, "Principal", {})] : []
        content {
          type        = lookup(principals.value, "Type", null)
          identifiers = lookup(principals.value, "Identifiers", null)
        }
      }

      dynamic "condition" {
        # Handle optional condition block
        for_each = lookup(statement.value, "Condition", null) != null ? [lookup(statement.value, "Condition", {})] : []
        content {
          test     = condition.value.Test # Assuming Condition = { Test = { Operator = { Key = Value } } } structure
          variable = condition.value.Variable
          values   = condition.value.Values
        }
      }
    }
  }
}
