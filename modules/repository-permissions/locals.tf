locals {
  # Flag to enable/disable the entire module
  is_enabled = var.is_enabled

  # Flag to determine if the policy resource should be created.
  # The resource requires a policy document, which is constructed in data.tf.
  # We create the resource if the module is enabled.
  create_policy = local.is_enabled

  # Determine effective owner (current account or specified)
  effective_domain_owner = coalesce(var.domain_owner, data.aws_caller_identity.current.account_id)

  # Construct the repository ARN needed for policy statements
  repository_arn = "arn:${data.aws_partition.current.partition}:codeartifact:${data.aws_region.current.name}:${local.effective_domain_owner}:repository/${var.domain_name}/${var.repository_name}"

  # Construct the domain ARN needed for GetAuthorizationToken action
  domain_arn = "arn:${data.aws_partition.current.partition}:codeartifact:${data.aws_region.current.name}:${local.effective_domain_owner}:domain/${var.domain_name}"
}
