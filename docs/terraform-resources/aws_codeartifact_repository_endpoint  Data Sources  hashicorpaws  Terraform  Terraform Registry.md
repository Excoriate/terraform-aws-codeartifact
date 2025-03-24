The CodeArtifact Repository Endpoint data source returns the endpoint of a repository for a specific package format.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
data "aws_codeartifact_repository_endpoint" "test" { domain = aws_codeartifact_domain.test.domain repository = aws_codeartifact_repository.test.repository format = "npm" }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This data source supports the following arguments:

-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-7) - (Required) Name of the domain that contains the repository.
-   [`repository`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository-4) - (Required) Name of the repository.
-   [`format`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#format-2) - (Required) Which endpoint of a repository to return. A repository has one endpoint for each package format: `npm`, `pypi`, `maven`, and `nuget`.
-   [`domain_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain_owner-6) - (Optional) Account number of the AWS account that owns the domain.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This data source exports the following attributes in addition to the arguments above:

-   [`repository_endpoint`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository_endpoint-2) - URL of the returned endpoint.