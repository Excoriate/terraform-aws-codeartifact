# Combined Proxy repository fixture - defines both internal upstreams and external connections.
# Replace "your-actual-domain-name" with a valid CodeArtifact domain.
# Replace "your-internal-upstream-repo" with the name of another existing repository in the same domain.
domain_name = "your-actual-domain-name"

upstreams = [
  { repository_name = "your-internal-upstream-repo" }
]

external_connections = [
  "public:npmjs"
]

# You could override other defaults here if needed, e.g.:
# repository_name = "my-combined-proxy-repo"
# description       = "Combined internal and public proxy repository"
