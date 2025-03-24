Provides a CodeArtifact Repository Resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
resource "aws_kms_key" "example" { description = "domain key" } resource "aws_codeartifact_domain" "example" { domain = "example" encryption_key = aws_kms_key.example.arn } resource "aws_codeartifact_repository" "test" { repository = "example" domain = aws_codeartifact_domain.example.domain }
```

## [Example Usage with upstream repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage-with-upstream-repository)

```terraform
resource "aws_codeartifact_repository" "upstream" { repository = "upstream" domain = aws_codeartifact_domain.test.domain } resource "aws_codeartifact_repository" "test" { repository = "example" domain = aws_codeartifact_domain.example.domain upstream { repository_name = aws_codeartifact_repository.upstream.repository } }
```

## [Example Usage with external connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage-with-external-connection)

```terraform
resource "aws_codeartifact_repository" "upstream" { repository = "upstream" domain = aws_codeartifact_domain.test.domain } resource "aws_codeartifact_repository" "test" { repository = "example" domain = aws_codeartifact_domain.example.domain external_connections { external_connection_name = "public:npmjs" } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This resource supports the following arguments:

-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-4) - (Required) The domain that contains the created repository.
-   [`repository`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository-2) - (Required) The name of the repository to create.
-   [`domain_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain_owner-3) - (Optional) The account number of the AWS account that owns the domain.
-   [`description`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#description-1) - (Optional) The description of the repository.
-   [`upstream`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#upstream-1) - (Optional) A list of upstream repositories to associate with the repository. The order of the upstream repositories in the list determines their priority order when AWS CodeArtifact looks for a requested package version. see [Upstream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#upstream)
-   [`external_connections`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#external_connections-1) - An array of external connections associated with the repository. Only one external connection can be set per repository. see [External Connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#external-connections).
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#tags-4) - (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

### [Upstream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#upstream)

-   [`repository_name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository_name-1) - (Required) The name of an upstream repository.

### [External Connections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#external-connections)

-   [`external_connection_name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#external_connection_name-1) - (Required) The name of the external connection associated with a repository.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#id-3) - The ARN of the repository.
-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#arn-2) - The ARN of the repository.
-   [`administrator_account`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#administrator_account-1) - The account number of the AWS account that manages the repository.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#tags_all-2) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import CodeArtifact Repository using the CodeArtifact Repository ARN. For example:

```terraform
import { to = aws_codeartifact_repository.example id = "arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763" }
```

Using `terraform import`, import CodeArtifact Repository using the CodeArtifact Repository ARN. For example:

```console
% terraform import aws_codeartifact_repository.example arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763
```