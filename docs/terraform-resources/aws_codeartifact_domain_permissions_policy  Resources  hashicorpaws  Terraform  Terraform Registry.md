Provides a CodeArtifact Domains Permissions Policy Resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
resource "aws_kms_key" "example" { description = "domain key" } resource "aws_codeartifact_domain" "example" { domain = "example" encryption_key = aws_kms_key.example.arn } data "aws_iam_policy_document" "test" { statement { effect = "Allow" principals { type = "*" identifiers = ["*"] } actions = ["codeartifact:CreateRepository"] resources = [aws_codeartifact_domain.example.arn] } } resource "aws_codeartifact_domain_permissions_policy" "test" { domain = aws_codeartifact_domain.example.domain policy_document = data.aws_iam_policy_document.test.json }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This resource supports the following arguments:

-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-3) - (Required) The name of the domain on which to set the resource policy.
-   [`policy_document`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#policy_document-1) - (Required) A JSON policy string to be set as the access control resource policy on the provided domain.
-   [`domain_owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain_owner-2) - (Optional) The account number of the AWS account that owns the domain.
-   [`policy_revision`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#policy_revision-1) - (Optional) The current revision of the resource policy to be set. This revision is used for optimistic locking, which prevents others from overwriting your changes to the domain's resource policy.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#id-2) - The Name of Domain.
-   [`resource_arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#resource_arn-1) - The ARN of the resource associated with the resource policy.

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import CodeArtifact Domain Permissions Policies using the CodeArtifact Domain ARN. For example:

```terraform
import { to = aws_codeartifact_domain_permissions_policy.example id = "arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-1928056699409417367" }
```

Using `terraform import`, import CodeArtifact Domain Permissions Policies using the CodeArtifact Domain ARN. For example:

```console
% terraform import aws_codeartifact_domain_permissions_policy.example arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-1928056699409417367
```