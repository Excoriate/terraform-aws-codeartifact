data "aws_partition" "current" {}

###################################
# Trust Policy for Cross-Account Role
# -----------------------------------
# This policy allows external principals defined in var.external_principals
# to assume the IAM role created by this module.
###################################
data "aws_iam_policy_document" "trust_policy" {
  # Only generate if module is enabled, otherwise resources referencing this will fail
  for_each = var.is_enabled ? toset(["enabled"]) : toset([])

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # Format principals correctly as a list of ARNs
      identifiers = [
        for principal in var.external_principals :
        "arn:${data.aws_partition.current.partition}:iam::${principal.account_id}:role/${principal.role_name}"
      ]
    }
  }
}

# Removed data.aws_iam_policy_document.permissions as permissions are now defined via var.policies
