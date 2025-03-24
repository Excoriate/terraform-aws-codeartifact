The CodeArtifact Authorization Token data source generates a temporary authentication token for accessing repositories in a CodeArtifact domain.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
data "aws_codeartifact_authorization_token" "test" { domain = aws_codeartifact_domain.test.domain }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This data source supports the following arguments:

-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-6) - (Required) Name of the domain that is in scope for the generated authorization token.
-   [`domain_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain_owner-5) - (Optional) Account number of the AWS account that owns the domain.
-   [`duration_seconds`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#duration_seconds-1) - (Optional) Time, in seconds, that the generated authorization token is valid. Valid values are `0` and between `900` and `43200`.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This data source exports the following attributes in addition to the arguments above:

-   [`authorization_token`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#authorization_token-1) - Temporary authorization token.
-   [`expiration`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#expiration-1) - Time in UTC RFC3339 format when the authorization token expires.