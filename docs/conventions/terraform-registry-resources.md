# AWS CodeArtifact Terraform Registry Documentation

## Table of Contents

1. [AWS CodeArtifact Authorization Token](#aws-codeartifact-authorization-token)
2. [AWS CodeArtifact Domain](#aws-codeartifact-domain)
3. [AWS CodeArtifact Domain Permissions Policy](#aws-codeartifact-domain-permissions-policy)
4. [AWS CodeArtifact Repository](#aws-codeartifact-repository)
5. [AWS CodeArtifact Repository Endpoint](#aws-codeartifact-repository-endpoint)
6. [AWS CodeArtifact Repository Permissions Policy](#aws-codeartifact-repository-permissions-policy)

## AWS CodeArtifact Authorization Token

The CodeArtifact Authorization Token data source generates a temporary authentication token for accessing repositories in a CodeArtifact domain.

### Example Usage

```terraform
data "aws_codeartifact_authorization_token" "test" {
  domain = aws_codeartifact_domain.test.domain
}
```

### Argument Reference

This data source supports the following arguments:

- `domain` - (Required) Name of the domain that is in scope for the generated authorization token.
- `domain_owner` - (Optional) Account number of the AWS account that owns the domain.
- `duration_seconds` - (Optional) Time, in seconds, that the generated authorization token is valid. Valid values are `0` and between `900` and `43200`.

### Attribute Reference

This data source exports the following attributes in addition to the arguments above:

- `authorization_token` - Temporary authorization token.
- `expiration` - Time in UTC RFC3339 format when the authorization token expires.

## AWS CodeArtifact Domain

Provides a CodeArtifact Domain Resource.

### Example Usage

```terraform
resource "aws_codeartifact_domain" "example" {
  domain = "example"
}
```

```terraform
resource "aws_kms_key" "example" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "example" {
  domain         = "example"
  encryption_key = aws_kms_key.example.arn
}
```

### Argument Reference

This resource supports the following arguments:

- `domain` - (Required) The name of the domain to create. All domain names in an AWS Region that are in the same AWS account must be unique. The domain name is used as the prefix in DNS hostnames. Do not use sensitive information in a domain name because it is publicly discoverable.
- `encryption_key` - (Optional) The encryption key for the domain. This is used to encrypt content stored in a domain. The KMS Key Amazon Resource Name (ARN). The default aws/codeartifact AWS KMS master key is used if this element is absent.
- `tags` - (Optional) Key-value map of resource tags.

### Attribute Reference

This resource exports the following attributes in addition to the arguments above:

- `id` - The ARN of the Domain.
- `arn` - The ARN of the Domain.
- `owner` - The AWS account ID that owns the domain.
- `repository_count` - The number of repositories in the domain.
- `s3_bucket_arn` - The ARN of the Amazon S3 bucket that is used to store package assets in the domain.
- `created_time` - A timestamp that represents the date and time the domain was created in RFC3339 format.
- `asset_size_bytes` - The total size of all assets in the domain.
- `tags_all` - A map of tags assigned to the resource.

### Import

```terraform
import {
  to = aws_codeartifact_domain.example
  id = "arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-8593714120730241305"
}
```

## AWS CodeArtifact Domain Permissions Policy

Provides a CodeArtifact Domains Permissions Policy Resource.

### Example Usage

```terraform
resource "aws_kms_key" "example" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "example" {
  domain         = "example"
  encryption_key = aws_kms_key.example.arn
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["codeartifact:CreateRepository"]
    resources = [aws_codeartifact_domain.example.arn]
  }
}

resource "aws_codeartifact_domain_permissions_policy" "test" {
  domain           = aws_codeartifact_domain.example.domain
  policy_document  = data.aws_iam_policy_document.test.json
}
```

### Argument Reference

This resource supports the following arguments:

- `domain` - (Required) The name of the domain on which to set the resource policy.
- `policy_document` - (Required) A JSON policy string to be set as the access control resource policy on the provided domain.
- `domain_owner` - (Optional) The account number of the AWS account that owns the domain.
- `policy_revision` - (Optional) The current revision of the resource policy to be set.

### Attribute Reference

This resource exports the following attributes in addition to the arguments above:

- `id` - The Name of Domain.
- `resource_arn` - The ARN of the resource associated with the resource policy.

### Import

```terraform
import {
  to = aws_codeartifact_domain_permissions_policy.example
  id = "arn:aws:codeartifact:us-west-2:012345678912:domain/tf-acc-test-1928056699409417367"
}
```

## AWS CodeArtifact Repository

Provides a CodeArtifact Repository Resource.

### Example Usage

```terraform
resource "aws_kms_key" "example" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "example" {
  domain         = "example"
  encryption_key = aws_kms_key.example.arn
}

resource "aws_codeartifact_repository" "test" {
  repository = "example"
  domain     = aws_codeartifact_domain.example.domain
}
```

### Example Usage with Upstream Repository

```terraform
resource "aws_codeartifact_repository" "upstream" {
  repository = "upstream"
  domain     = aws_codeartifact_domain.test.domain
}

resource "aws_codeartifact_repository" "test" {
  repository = "example"
  domain     = aws_codeartifact_domain.example.domain

  upstream {
    repository_name = aws_codeartifact_repository.upstream.repository
  }
}
```

### Example Usage with External Connection

```terraform
resource "aws_codeartifact_repository" "upstream" {
  repository = "upstream"
  domain     = aws_codeartifact_domain.test.domain
}

resource "aws_codeartifact_repository" "test" {
  repository = "example"
  domain     = aws_codeartifact_domain.example.domain

  external_connections {
    external_connection_name = "public:npmjs"
  }
}
```

### Argument Reference

This resource supports the following arguments:

- `domain` - (Required) The domain that contains the created repository.
- `repository` - (Required) The name of the repository to create.
- `domain_owner` - (Optional) The account number of the AWS account that owns the domain.
- `description` - (Optional) The description of the repository.
- `upstream` - (Optional) A list of upstream repositories to associate with the repository.
- `external_connections` - (Optional) An array of external connections associated with the repository.
- `tags` - (Optional) Key-value map of resource tags.

### Attribute Reference

This resource exports the following attributes in addition to the arguments above:

- `id` - The ARN of the repository.
- `arn` - The ARN of the repository.
- `administrator_account` - The account number of the AWS account that manages the repository.
- `tags_all` - A map of tags assigned to the resource.

### Import

```terraform
import {
  to = aws_codeartifact_repository.example
  id = "arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763"
}
```

## AWS CodeArtifact Repository Endpoint

The CodeArtifact Repository Endpoint data source returns the endpoint of a repository for a specific package format.

### Example Usage

```terraform
data "aws_codeartifact_repository_endpoint" "test" {
  domain     = aws_codeartifact_domain.test.domain
  repository = aws_codeartifact_repository.test.repository
  format     = "npm"
}
```

### Argument Reference

This data source supports the following arguments:

- `domain` - (Required) Name of the domain that contains the repository.
- `repository` - (Required) Name of the repository.
- `format` - (Required) Which endpoint of a repository to return. A repository has one endpoint for each package format: `npm`, `pypi`, `maven`, and `nuget`.
- `domain_owner` - (Optional) Account number of the AWS account that owns the domain.

### Attribute Reference

This data source exports the following attributes in addition to the arguments above:

- `repository_endpoint` - URL of the returned endpoint.

## AWS CodeArtifact Repository Permissions Policy

Provides a CodeArtifact Repository Permissions Policy Resource.

### Example Usage

```terraform
resource "aws_kms_key" "example" {
  description = "domain key"
}

resource "aws_codeartifact_domain" "example" {
  domain         = "example"
  encryption_key = aws_kms_key.example.arn
}

resource "aws_codeartifact_repository" "example" {
  repository = "example"
  domain     = aws_codeartifact_domain.example.domain
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["codeartifact:ReadFromRepository"]
    resources = [aws_codeartifact_repository.example.arn]
  }
}

resource "aws_codeartifact_repository_permissions_policy" "example" {
  repository       = aws_codeartifact_repository.example.repository
  domain           = aws_codeartifact_domain.example.domain
  policy_document  = data.aws_iam_policy_document.example.json
}
```

### Argument Reference

This resource supports the following arguments:

- `repository` - (Required) The name of the repository to set the resource policy on.
- `domain` - (Required) The name of the domain on which to set the resource policy.
- `policy_document` - (Required) A JSON policy string to be set as the access control resource policy on the provided domain.
- `domain_owner` - (Optional) The account number of the AWS account that owns the domain.
- `policy_revision` - (Optional) The current revision of the resource policy to be set.

### Attribute Reference

This resource exports the following attributes in addition to the arguments above:

- `id` - The ARN of the resource associated with the resource policy.
- `resource_arn` - The ARN of the resource associated with the resource policy.

### Import

```terraform
import {
  to = aws_codeartifact_repository_permissions_policy.example
  id = "arn:aws:codeartifact:us-west-2:012345678912:repository/tf-acc-test-6968272603913957763/tf-acc-test-6968272603913957763"
}
```
