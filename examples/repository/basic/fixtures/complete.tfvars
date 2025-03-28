# Complete fixture - demonstrates all optional features
# This creates a domain with KMS encryption and a repository with all optional features

# Enable module
is_enabled = true

# Domain configuration with KMS encryption
domain_name    = "example-complete-domain"
create_kms_key = true
kms_key_deletion_window = 7

# Repository configuration
repository_name = "my-complete-repository-example"
description     = "Complete repository example with all features enabled"

# Enable all optional features
create_upstream_repository     = true
enable_npm_external_connection = true
create_policy                  = true

# Custom tags
tags = {
  Example     = "complete-repository"
  Environment = "development"
  ManagedBy   = "Terraform"
  Project     = "CodeArtifact Demo"
}
