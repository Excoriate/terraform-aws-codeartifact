# AWS CodeArtifact Domain Architecture

This document describes the architecture implemented by the `terraform-aws-codeartifact-domain` module, focusing on the Domain layer and its relationship to the overall AWS CodeArtifact setup.

## Architecture Overview

The `domain` module is a core component within the layered architecture for managing AWS CodeArtifact. It establishes the primary organizational boundary for repositories and packages.

```mermaid
graph TD
    subgraph "Foundation Layer"
        KMS[KMS Encryption Key]
    end

    subgraph "Domain Layer"
        DomainResource[aws_codeartifact_domain]
        DomainPolicyResource[aws_codeartifact_domain_permissions_policy (Optional)]
    end

    subgraph "Repositories Layer"
        Repositories[CodeArtifact Repositories]
    end

    subgraph "Security Layer"
        IAM[IAM Principals/Roles]
    end

    %% Connections
    KMS --> DomainResource
    DomainResource --> Repositories
    DomainResource --> DomainPolicyResource
    IAM --> DomainPolicyResource

    classDef foundation fill:#FFD700,stroke:#232F3E,color:#232F3E;
    classDef domainLayer fill:#ADD8E6,stroke:#232F3E,color:#232F3E;
    classDef repositoryLayer fill:#90EE90,stroke:#232F3E,color:#232F3E;
    classDef securityLayer fill:#FFA07A,stroke:#232F3E,color:#232F3E;

    class KMS foundation;
    class DomainResource, DomainPolicyResource domainLayer;
    class Repositories repositoryLayer;
    class IAM securityLayer;
```

## Domain Layer

The Domain Layer, managed by this module, creates and configures the AWS CodeArtifact Domain. A domain is a high-level container that groups repositories.

### Key Components

#### CodeArtifact Domain (`aws_codeartifact_domain`)

This is the primary resource managed by the module.

*   **Capabilities**:
    *   Creates a unique CodeArtifact domain within an AWS account and region.
    *   Configures domain-level encryption using a specified AWS KMS key (or the AWS-managed key if none is provided).
    *   Acts as the container for multiple CodeArtifact repositories.
    *   Provides a unique endpoint for interacting with the domain and its repositories.
*   **Use Cases**:
    *   **Centralized Package Management (UC-3)**: Establishes the organizational boundary for sharing internal packages and managing external dependencies.
    *   **Environment Isolation**: Separate domains can be used for different environments (dev, staging, prod) if required, although often repositories within a single domain are used.
    *   **Cross-Account Foundation**: Defines the domain that might be shared or accessed across accounts (permissions managed separately).

#### Domain Permissions Policy (`aws_codeartifact_domain_permissions_policy`) (Optional)

This resource is optionally managed by the `domain` module if `enable_domain_permissions_policy` is set to `true`.

*   **Capabilities**:
    *   Applies an IAM resource-based policy directly to the CodeArtifact domain.
    *   Controls domain-level actions like `CreateRepository`, `GetAuthorizationToken`, `ListRepositoriesInDomain`.
*   **Use Cases**:
    *   **Initial Access Control (UC-3)**: Sets baseline permissions for the domain upon creation, defining who can create repositories or perform other domain-wide actions.
    *   **Simplified Setup**: Allows defining basic domain permissions alongside domain creation for simpler scenarios.
    *   **Note**: For more complex or separately managed policies, the dedicated `domain-permissions` module should be used instead of enabling this within the `domain` module.

### Domain Layer Use Cases

This module directly supports:

#### Establishing Organizational Structure (UC-3)

1.  **Process Flow**:
    *   The module is invoked with a unique `domain_name`.
    *   An `aws_codeartifact_domain` resource is created.
    *   Encryption is configured using the provided `kms_key_arn` or the default AWS key.
    *   Optionally, an initial `aws_codeartifact_domain_permissions_policy` is attached.
2.  **Benefits**:
    *   Creates the fundamental container required for all CodeArtifact repositories.
    *   Ensures domain assets are encrypted according to requirements.
    *   Provides the necessary outputs (ARN, name, endpoint) for subsequent repository and security configurations.

### Integration with Other Layers

1.  **Foundation Layer**:
    *   Requires `kms_key_arn` from the Foundation layer for domain encryption.
2.  **Repositories Layer**:
    *   Provides `domain_name` and `domain_owner` required by the Repositories layer to create repositories within this domain.
3.  **Security Layer / Domain Permissions Module**:
    *   Provides `domain_name` and `domain_owner` required by the `domain-permissions` module or other security configurations to apply policies to this domain.
    *   Can optionally manage the initial domain policy itself.

## Implementation Details

*   **Main Resource**: `aws_codeartifact_domain`
*   **Optional Resource**: `aws_codeartifact_domain_permissions_policy`
*   **Key Inputs**: `domain_name`, `kms_key_arn`, `tags`, `enable_domain_permissions_policy`, `domain_permissions_policy`, `domain_owner`
*   **Key Outputs**: `domain_arn`, `domain_name`, `domain_owner`, `domain_endpoint`, `domain_encryption_key`

## Conclusion

The `terraform-aws-codeartifact-domain` module is essential for establishing the core CodeArtifact domain. It creates the primary resource, configures encryption, and optionally sets initial permissions, providing the foundation upon which repositories and access controls are built.
