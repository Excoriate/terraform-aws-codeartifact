locals {
  # Define common tags for all resources created by this module
  common_tags = {
    ManagedBy = "Terraform"
    Module    = "repository" # Identifies resources managed by this specific module
  }

  # Merge common tags with user-provided tags. User tags take precedence.
  tags = merge(local.common_tags, var.tags)

  # Flag to determine if the main repository resource should be created
  create_repository = var.is_enabled

  # Flag to determine if the repository policy should be created.
  # Requires the module to be enabled AND a policy document to be provided.
  create_policy = var.is_enabled && var.repository_policy_document != null
}
