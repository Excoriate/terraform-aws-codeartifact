# Hosted repository fixture - explicitly no upstreams or external connections.
# Replace "your-actual-domain-name" with a valid CodeArtifact domain.
domain_name = "your-actual-domain-name"

# Explicitly set optional connection variables to null for clarity, even though it's the default.
upstreams            = null
external_connections = null

# You could override other defaults here if needed for a specific hosted scenario, e.g.:
# repository_name = "my-specific-hosted-repo"
# description       = "A hosted repository for project X"
# tags = {
#   Purpose = "Hosted"
# }
