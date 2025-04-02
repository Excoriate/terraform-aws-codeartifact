# Default fixture - uses standard configuration for self-contained example
# This creates a basic CodeArtifact domain and repository with minimal configuration

# Enable module
is_enabled = true

# Domain configuration
domain_name = "example-basic-domain"

# Repository configuration
repository_name = "my-basic-repository-example"
description     = "Basic repository example with minimal configuration"

# Optional features disabled by default
create_kms_key                 = false
create_upstream_repository     = false
enable_npm_external_connection = false
create_policy                  = false

# Tags are inherited from variables.tf defaults
