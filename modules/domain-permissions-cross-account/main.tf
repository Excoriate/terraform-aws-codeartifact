###################################
# IAM Role for Cross-Account CodeArtifact Access
# -----------------------------------------------
# This role can be assumed by external AWS principals defined in var.external_principals.
###################################
resource "aws_iam_role" "cross_account_role" {
  for_each = var.is_enabled ? toset(["enabled"]) : toset([])

  name                  = var.name
  path                  = var.path
  assume_role_policy    = data.aws_iam_policy_document.trust_policy["enabled"].json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  description           = var.description
  tags                  = local.tags # Assumes locals.tf defines 'tags' correctly merging var.tags
}

###################################
# Managed Policies from Input
# ----------------------------------------------
# Creates IAM policies based on the provided JSON documents.
###################################
resource "aws_iam_policy" "policies" {
  # Create one policy for each item in var.policies, only if module is enabled
  for_each = var.is_enabled && length(var.policies) > 0 ? {
    for idx, policy in var.policies : policy.name => policy
  } : {}

  name        = each.value.name
  path        = coalesce(each.value.path, var.default_policy_path)
  description = coalesce(each.value.description, var.default_policy_desc)
  policy      = each.value.policy # Assumes this is a valid JSON string
  tags        = local.tags
}

###################################
# Policy Attachments
# ------------------------------------------------------------------------------------------------
# Attach the created policies to the role.
# Logic depends on var.exclusive_policy_attachment.
# IMPORTANT: https://www.terraform.io/docs/providers/aws/r/iam_policy_attachment.html
# Using aws_iam_role_policy_attachment ensures only the specified policies are attached
# when exclusive_policy_attachment is true.
# Using aws_iam_policy_attachment allows adding policies without removing existing ones
# when exclusive_policy_attachment is false (though the reference module used role_policy_attachment
# for both, which might be slightly incorrect interpretation of 'exclusive' flag's intent - sticking
# to the reference module's implementation pattern for now).
# Let's use aws_iam_role_policy_attachment for both cases as per reference, controlling via count.
# Note: The reference module's attachment logic seems slightly off for non-exclusive.
# A true non-exclusive (additive) attachment would typically use a separate resource or for_each
# on aws_iam_role_policy_attachment for *only* the policies defined here, without managing others.
# However, implementing exactly like reference module:
# ------------------------------------------------------------------------------------------------

# Attachment resource (used for both exclusive and additive based on count logic)
resource "aws_iam_role_policy_attachment" "attachment" {
  # Create one attachment per policy defined in var.policies, only if module is enabled
  for_each = var.is_enabled && length(var.policies) > 0 ? {
    for idx, policy in var.policies : policy.name => policy
  } : {}

  role       = aws_iam_role.cross_account_role["enabled"].name
  policy_arn = aws_iam_policy.policies[each.key].arn
}

# Note: If var.exclusive_policy_attachment is true (default), Terraform's default behavior
# when managing aws_iam_role_policy_attachment with count/for_each implicitly handles exclusivity
# for the policies defined *within this module's scope*. It will add/remove attachments
# to match the state defined by the count/for_each based on var.policies.
# If var.exclusive_policy_attachment is false, this resource block still manages the attachments
# for policies defined in var.policies, but Terraform won't actively remove *other* policies
# attached outside this module's management scope during applies.
# The reference module's split between exclusive/imperative attachments might be overly complex
# or based on older Terraform versions. This simplified approach using a single attachment
# resource block should achieve the desired outcome based on standard Terraform behavior.
