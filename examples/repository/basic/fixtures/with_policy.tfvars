# With Policy repository fixture - defines a repository_policy_document.
# Replace "your-actual-domain-name" with a valid CodeArtifact domain.
# Replace "111122223333" with a valid AWS Account ID.
domain_name = "your-actual-domain-name"

# Keep other optional connection variables null/default for this specific test
upstreams            = null
external_connections = null

# Example policy allowing read access for another account
repository_policy_document = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Sid    = "AllowCrossAccountRead",
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::111122223333:root" # Replace with actual account ID
      },
      Action = [
        "codeartifact:DescribePackageVersion",
        "codeartifact:DescribeRepository",
        "codeartifact:GetPackageVersionReadme",
        "codeartifact:GetRepositoryEndpoint",
        "codeartifact:ListPackages",
        "codeartifact:ListPackageVersions",
        "codeartifact:ListPackageVersionAssets",
        "codeartifact:ListPackageVersionDependencies",
        "codeartifact:ReadFromRepository"
      ],
      Resource = "*" # Policy applies to the repository resource itself
    }
  ]
})

# You could override other defaults here if needed, e.g.:
# repository_name = "my-policy-repo"
# description       = "Repository with a custom policy"
