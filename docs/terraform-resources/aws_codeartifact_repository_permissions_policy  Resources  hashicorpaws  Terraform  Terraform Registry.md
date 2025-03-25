Provides a CodeArtifact Repostory Permissions Policy Resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
resource "aws_kms_key" "example" { description = "domain key" } resource "aws_codeartifact_domain" "example" { domain = "example" encryption_key = aws_kms_key.example.arn } resource "aws_codeartifact_repository" "example" { repository = "example" domain = aws_codeartifact_domain.example.domain } data "aws_iam_policy_document" "example" { statement { effect = "Allow" principals { type = "*" identifiers = ["*"] } actions = ["codeartifact:ReadFromRepository"] resources = [aws_codeartifact_repository.example.arn] } } resource "aws_codeartifact_repository_permissions_policy" "example" { repository = aws_codeartifact_repository.example.repository domain = aws_codeartifact_domain.example.domain policy_document = data.aws_iam_policy_document.example.json }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This resource supports the following arguments:

-   [`repository`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository-3) - (Required) The name of the repository to set the resource policy on.
-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-5) - (Required) The name of the domain on which to set the resource policy.
-   [`policy_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#policy_document-2) - (Required) A JSON policy string to be set as the access control resource policy on the provided domain.
-   [`domain_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain_owner-4) - (Optional) The account number of the AWS account that owns the domain.
-   [`policy_revision`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#policy_revision-2) - (Optional) The current revision of the resource policy to be set. This revision is used for optimistic locking, which prevents others from overwriting your changes to the domain's resource policy.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#id-4) - The ARN of the resource associated with the resource policy.
-   [`resource_arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#resource_arn-2) - The ARN of the resource associated with the resource policy.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import CodeArtifact Repository Permissions Policies using the CodeArtifact Repository ARN. For example:

```terraform
import { to = aws_codeartifact_repository_permissions_policy.example id = "arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763" }
```

Using `terraform import`, import CodeArtifact Repository Permissions Policies using the CodeArtifact Repository ARN. For example:

```console
% terraform import aws_codeartifact_repository_permissions_policy.example arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763
```
