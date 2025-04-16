data "aws_partition" "current" {}

###################################
# Trust Policy for Cross-Account Role
# -----------------------------------
# This policy allows external principals defined in var.external_principals
# to assume the IAM role created by this module.
###################################
data "aws_iam_policy_document" "trust_policy" {
  # Only generate if module is enabled, otherwise resources referencing this will fail
  for_each = var.is_enabled && length(var.external_principals) > 0 && length(var.external_principals_arns_override) == 0 ? toset(["enabled"]) : toset([])

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # Format principals correctly as a list of ARNs
      identifiers = [
        for principal in var.external_principals :
        principal.full_arn_override != "" ? principal.full_arn_override : "arn:${data.aws_partition.current.partition}:iam::${principal.account_id}:role/${principal.role_name}"
      ]
    }
  }
}

# Trust Policy for Cross-Account Role with Override
# -------------------------------------------------
# This policy allows external principals defined in var.external_principals_arns_override
# to assume the IAM role created by this module.
###################################
data "aws_iam_policy_document" "trust_policy_override" {
  for_each = var.is_enabled && length(var.external_principals_arns_override) > 0 ? toset(["enabled"]) : toset([])

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.external_principals_arns_override
    }
  }
}
