# This main.tf file demonstrates basic usage of the repository module with a self-contained example.
# All required resources are created by this example, including the CodeArtifact domain.
# Input variables defined in variables.tf are passed to the module.
# Different configurations can be tested using .tfvars files in the fixtures/ directory
# (e.g., terraform plan -var-file=fixtures/disabled.tfvars)

# Create a KMS key for domain encryption (optional but recommended for production)
resource "aws_kms_key" "this" {
  count = var.is_enabled && var.create_kms_key ? 1 : 0

  description             = "KMS key for CodeArtifact domain encryption"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  tags                    = var.tags
}

# Create a CodeArtifact domain first - required for repositories
resource "aws_codeartifact_domain" "this" {
  count = var.is_enabled ? 1 : 0

  domain         = var.domain_name
  encryption_key = var.create_kms_key ? aws_kms_key.this[0].arn : null
  tags           = var.tags
}

# Now call the repository module
module "this" {
  source = "../../../modules/repository"

  # Required inputs
  is_enabled      = var.is_enabled
  domain_name     = var.is_enabled ? aws_codeartifact_domain.this[0].domain : var.domain_name
  repository_name = var.repository_name

  # Optional features configurable through fixtures
  description = var.description

  # Optional external connections (can be enabled via fixtures)
  external_connections = var.enable_npm_external_connection ? ["public:npmjs"] : null

  # Optional policy document (null in basic example)
  repository_policy_document = var.create_policy ? data.aws_iam_policy_document.repository_policy[0].json : null

  # Tags
  tags = var.tags
}

# Optional: Create a policy document for repository permissions
data "aws_iam_policy_document" "repository_policy" {
  count = var.is_enabled && var.create_policy ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["codeartifact:ReadFromRepository"]
    resources = [module.this.repository_arn]
  }
}

# Optional: Query the repository endpoint for a specific package format
# This demonstrates how to get the repository endpoint for npm packages
data "aws_codeartifact_repository_endpoint" "npm" {
  count = var.is_enabled && var.enable_npm_external_connection ? 1 : 0

  domain     = aws_codeartifact_domain.this[0].domain
  repository = module.this.repository_name
  format     = "npm"
}
