# Internal Proxy repository fixture - defines internal upstreams.
# Replace "your-actual-domain-name" with a valid CodeArtifact domain.
# Replace "your-internal-upstream-repo" with the name of another existing repository in the same domain.
domain_name = "your-actual-domain-name"

upstreams = [
  { repository_name = "your-internal-upstream-repo" }
  # Add more upstream repositories here if needed
  # { repository_name = "another-internal-repo" }
]

external_connections = null

# You could override other defaults here if needed, e.g.:
# repository_name = "my-internal-proxy-repo"
# description       = "Internal proxy repository"
