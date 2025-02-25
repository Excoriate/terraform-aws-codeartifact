# AWS CodeArtifact Terraform Resource Composition Rules

## Overview

This document provides comprehensive rules and guidelines for composing AWS CodeArtifact resources in Terraform, focusing on best practices, security considerations, and architectural patterns.

## Detailed Resource Specifications

### AWS CodeArtifact Authorization Token Rules

#### Configuration Guidelines
1. **Token Generation**:
   - MUST specify a valid domain
   - OPTIONAL domain owner specification
   - CONTROL token duration precisely

   ```terraform
   data "aws_codeartifact_authorization_token" "example" {
     domain         = aws_codeartifact_domain.test.domain
     domain_owner   = data.aws_caller_identity.current.account_id  # Optional
     duration_seconds = 900  # Recommended: Short-lived tokens
   }
   ```

2. **Duration Constraints**:
   - ALLOWED duration values: 0 or between 900 and 43200 seconds
   - PREFER shorter token lifespans
   - IMPLEMENT automatic token rotation mechanisms

#### Validation Rules
- VALIDATE token expiration timestamp
- SECURE token storage using AWS Secrets Manager
- NEVER log or print authorization tokens

### AWS CodeArtifact Domain Rules

#### Mandatory Configuration
1. **Domain Creation Requirements**:
   - MUST have unique name within AWS Region and Account
   - MAXIMUM name length: 90 characters
   - SUPPORT optional encryption key configuration

2. **Encryption Strategies**:
   - STRONGLY RECOMMEND custom KMS key
   - ENABLE key rotation
   - IMPLEMENT comprehensive key policies

   ```terraform
   resource "aws_kms_key" "domain_encryption" {
     description             = "CodeArtifact Domain Encryption Key"
     deletion_window_in_days = 10
     enable_key_rotation     = true
   }

   resource "aws_codeartifact_domain" "secure_domain" {
     domain         = "company-packages"
     encryption_key = aws_kms_key.domain_encryption.arn
     tags = {
       ManagedBy = "Terraform"
       Purpose   = "Package Management"
     }
   }
   ```

#### Advanced Configuration
- TRACK repository count
- MONITOR asset size
- IMPLEMENT comprehensive tagging strategy

### AWS CodeArtifact Domain Permissions Policy Rules

1. **Policy Composition**:
   - USE AWS IAM policy document for precise permissions
   - IMPLEMENT principle of least privilege
   - SPECIFY exact actions and resources

   ```terraform
   data "aws_iam_policy_document" "domain_permissions" {
     statement {
       effect = "Allow"
       principals {
         type        = "AWS"
         identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/allowed-role"]
       }
       actions = [
         "codeartifact:CreateRepository",
         "codeartifact:DescribeDomain"
       ]
       resources = [aws_codeartifact_domain.example.arn]
     }
   }

   resource "aws_codeartifact_domain_permissions_policy" "example" {
     domain          = aws_codeartifact_domain.example.domain
     policy_document = data.aws_iam_policy_document.domain_permissions.json
   }
   ```

2. **Policy Management**:
   - TRACK policy revisions
   - IMPLEMENT regular policy audits
   - USE version control for policy changes

### AWS CodeArtifact Repository Rules

#### Repository Configuration
1. **Basic Requirements**:
   - MUST be associated with a domain
   - SUPPORT upstream repositories
   - MANAGE external connections carefully

2. **Upstream Repository Configuration**:
   ```terraform
   resource "aws_codeartifact_repository" "internal_repo" {
     repository = "company-internal"
     domain     = aws_codeartifact_domain.example.domain

     upstream {
       repository_name = aws_codeartifact_repository.base.repository
     }
   }
   ```

3. **External Connections Management**:
   ```terraform
   resource "aws_codeartifact_repository" "npm_proxy" {
     repository = "npm-proxy"
     domain     = aws_codeartifact_domain.example.domain

     external_connections {
       external_connection_name = "public:npmjs"
     }
   }
   ```

#### Repository Endpoint Rules
1. **Endpoint Configuration**:
   - SUPPORT multiple package formats
   - VALIDATE format compatibility
   - SECURE endpoint access

   ```terraform
   data "aws_codeartifact_repository_endpoint" "npm_endpoint" {
     domain     = aws_codeartifact_domain.example.domain
     repository = aws_codeartifact_repository.example.repository
     format     = "npm"
   }
   ```

### AWS CodeArtifact Repository Permissions Policy

1. **Policy Design**:
   - IMPLEMENT granular access controls
   - USE specific IAM principals
   - DEFINE explicit repository actions

   ```terraform
   data "aws_iam_policy_document" "repo_policy" {
     statement {
       effect = "Allow"
       principals {
         type        = "AWS"
         identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/package-readers"]
       }
       actions = ["codeartifact:ReadFromRepository"]
       resources = [aws_codeartifact_repository.example.arn]
     }
   }

   resource "aws_codeartifact_repository_permissions_policy" "example" {
     repository      = aws_codeartifact_repository.example.repository
     domain         = aws_codeartifact_domain.example.domain
     policy_document = data.aws_iam_policy_document.repo_policy.json
   }
   ```

## Comprehensive Security Guidelines

### Package Management Security
1. **Origin Controls**:
   - IMPLEMENT package group configurations
   - BLOCK unauthorized package versions
   - SCAN packages before ingestion

2. **Dependency Management**:
   - LIMIT external connections
   - VALIDATE package sources
   - MONITOR package provenance

## Advanced Monitoring and Compliance

1. **Logging and Auditing**:
   - ENABLE AWS CloudTrail for CodeArtifact
   - SET UP CloudWatch alerts
   - TRACK repository and domain events

2. **Compliance Validation**:
   ```hcl
   variable "codeartifact_config" {
     type = object({
       domain_name      = string
       repository_name  = string
       package_formats  = list(string)
     })
     validation {
       condition     = can(regex("^[a-z0-9-]{1,90}$", var.codeartifact_config.domain_name))
       error_message = "Invalid domain name format."
     }
   }
   ```

## Compliance Checklist

- [ ] Encryption enabled for all domains
- [ ] Least privilege permissions implemented
- [ ] Comprehensive tagging strategy
- [ ] External connections minimized
- [ ] Package origin controls configured
- [ ] Regular policy and key rotations
- [ ] Monitoring and logging enabled

## AWS CodeArtifact Core Concepts: In-Depth Explanation

### Asset
An asset is an individual file stored in CodeArtifact associated with a package version. Examples include:
- npm `.tgz` files
- Maven POM and JAR files
- Python wheel or source distribution files

**Terraform Implication:** When managing repositories, consider how assets will be stored, versioned, and accessed.

### Domain
A domain is a high-level organizational container for repositories with key characteristics:
- Aggregates multiple repositories
- Stores all package assets and metadata
- Encrypts assets with a single AWS KMS key
- Enables organization-wide package management policies

**Terraform Configuration Example:**
```terraform
resource "aws_codeartifact_domain" "org_domain" {
  domain         = "company-packages"
  encryption_key = aws_kms_key.domain_encryption.arn
}
```

### Repository
Repositories in CodeArtifact are versatile package management containers:
- Can contain packages from multiple formats (polyglot)
- Support up to 1,000 repositories per domain
- Provide endpoints for various package managers (npm, Maven, pip, etc.)
- Can have upstream repository relationships

**Terraform Repository Configuration:**
```terraform
resource "aws_codeartifact_repository" "multi_format_repo" {
  repository = "company-packages"
  domain     = aws_codeartifact_domain.org_domain.domain

  # Optional: Configure upstream repositories
  upstream {
    repository_name = aws_codeartifact_repository.base_repo.repository
  }
}
```

### Package
A package is a software bundle with critical metadata:
- Consists of package name and optional namespace
- Contains multiple package versions
- Supports multiple formats:
  * Cargo
  * Maven
  * npm
  * NuGet
  * PyPI
  * Ruby
  * Swift

**Terraform Package Management Considerations:**
- Implement package group controls
- Define origin and ingestion policies
- Validate package sources

### Package Group
Package groups provide flexible configuration for multiple packages:
- Apply configurations based on package format, namespace, and name
- Implement package origin controls
- Protect against dependency substitution attacks

**Terraform Package Group Example:**
```terraform
resource "aws_codeartifact_package_group" "js_packages" {
  domain         = aws_codeartifact_domain.org_domain.domain
  pattern        = "@company/*"
  origin_config {
    restrictions = "ALLOW"
  }
}
```

### Package Namespace
Namespaces help organize packages and prevent name collisions:
- Supported in formats like npm and Maven
- Examples:
  * npm: `@types/node` (namespace: `@types`, name: `node`)
  * Maven: `org.apache.logging.log4j:log4j`
    (namespace: `org.apache.logging.log4j`, name: `log4j`)

### Package Version
A package version represents a specific iteration of a package:
- Unique identifier (e.g., `@types/node 12.6.9`)
- Follows format-specific versioning (e.g., Semantic Versioning for npm)
- Includes version metadata and assets

### Package Version Revision
A revision tracks specific changes to a package version:
- Created each time a package version is updated
- Helps track incremental changes
- Useful for managing package evolution

### Upstream Repository
Upstream repositories enable package sharing and reuse:
- Merge package contents across repositories
- Create hierarchical package management structures
- Facilitate internal and external package distribution

**Terraform Upstream Configuration:**
```terraform
resource "aws_codeartifact_repository" "internal_repo" {
  repository = "company-internal"
  domain     = aws_codeartifact_domain.org_domain.domain

  upstream {
    repository_name = aws_codeartifact_repository.public_proxy.repository
  }
}
```

## Enhanced Compliance and Best Practices

### Comprehensive Package Management Strategy
1. **Single Production Domain**: Consolidate packages in one domain
2. **Granular Access Controls**: Implement least-privilege permissions
3. **Regular Audits**: Monitor package origins and versions
4. **Encryption**: Use KMS for domain-level encryption
5. **Format Diversity**: Support multiple package ecosystems

### Security Enhancements
- Implement package group origin controls
- Use upstream repository management
- Regularly rotate access tokens
- Monitor package provenance
