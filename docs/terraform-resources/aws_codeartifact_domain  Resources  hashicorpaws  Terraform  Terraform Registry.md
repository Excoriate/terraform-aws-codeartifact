## Resource: aws\_codeartifact\_domain

Provides a CodeArtifact Domain Resource.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#example-usage)

```terraform
resource "aws_codeartifact_domain" "example" { domain = "example" }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#argument-reference)

This resource supports the following arguments:

-   [`domain`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#domain-2) - (Required) The name of the domain to create. All domain names in an AWS Region that are in the same AWS account must be unique. The domain name is used as the prefix in DNS hostnames. Do not use sensitive information in a domain name because it is publicly discoverable.
-   [`encryption_key`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#encryption_key-1) - (Optional) The encryption key for the domain. This is used to encrypt content stored in a domain. The KMS Key Amazon Resource Name (ARN). The default aws/codeartifact AWS KMS master key is used if this element is absent.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#tags-3) - (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`id`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#id-1) - The ARN of the Domain.
-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#arn-1) - The ARN of the Domain.
-   [`owner`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#owner-1) - The AWS account ID that owns the domain.
-   [`repository_count`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#repository_count-1) - The number of repositories in the domain.
-   [`s3_bucket_arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#s3_bucket_arn-1) - The ARN of the Amazon S3 bucket that is used to store package assets in the domain.
-   [`created_time`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#created_time-1) - A timestamp that represents the date and time the domain was created in [RFC3339 format](https://tools.ietf.org/html/rfc3339#section-5.8).
-   [`asset_size_bytes`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#asset_size_bytes-1) - The total size of all assets in the domain.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#tags_all-1) - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import CodeArtifact Domain using the CodeArtifact Domain arn. For example:

```terraform
import { to = aws_codeartifact_domain.example id = "arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-8593714120730241305" }
```

Using `terraform import`, import CodeArtifact Domain using the CodeArtifact Domain arn. For example:

```console
% terraform import aws_codeartifact_domain.example arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-8593714120730241305
```
