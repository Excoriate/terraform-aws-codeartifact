# Public Proxy repository fixture - defines external connections.
# Replace "your-actual-domain-name" with a valid CodeArtifact domain.
domain_name = "your-actual-domain-name"

upstreams = null

external_connections = [
  "public:npmjs"
  # Add other external connections here if needed, e.g., "public:pypi", "public:maven-central"
  # Note: AWS CodeArtifact may have limits on the number or combination of external connections.
]

# You could override other defaults here if needed, e.g.:
# repository_name = "my-public-proxy-repo"
# description       = "Public proxy repository for npm"
