# AWS CodeArtifact Domain Permissions Architecture

This document describes the architecture implemented by the `terraform-aws-codeartifact-domain-permissions` module, focusing on its role in managing access policies for an existing AWS CodeArtifact Domain.

## Architecture Overview

The `domain-permissions` module operates within the Security Layer of the overall AWS CodeArtifact architecture. Its primary function is to apply a resource-based policy to a CodeArtifact domain that has already been created (typically by the `domain` module).

```mermaid
graph TD
    subgraph "Domain Layer"
        DomainResource[aws_codeartifact_domain (Existing)]
    end

    subgraph "Security Layer"
        DomainPolicyResource[aws_codeartifact_domain_permissions_policy]
        IAM[IAM Principals/Roles]
        PolicyDefinition{Policy Definition}
    end

    %% Connections
    DomainResource --> DomainPolicyResource
    IAM --> PolicyDefinition
    PolicyDefinition --> DomainPolicyResource


    classDef domainLayer fill:#ADD8E6,stroke:#232F3E,color:#232F3E;
    classDef securityLayer fill:#FFA07A,stroke:#232F3E,color:#232F3E;

    class DomainResource domainLayer;
    class DomainPolicyResource, IAM, PolicyDefinition securityLayer;
```

## Domain Permissions Layer (Security Context)

This module specifically manages the `aws_codeartifact_domain_permissions_policy` resource, decoupling policy management from domain creation.

### Key Components

#### Domain Permissions Policy (`aws_codeartifact_domain_permissions_policy`)

This is the sole AWS resource managed by this module.

*   **Capabilities**:
    *   Applies or updates the resource-based policy on an existing CodeArtifact domain.
    *   Supports policy definition either dynamically (constructed from principal lists and custom statements) or via a complete JSON override.
    *   Handles cross-account domain ownership via the `domain_owner` input.
    *   Utilizes `policy_revision` for optimistic locking during updates.
*   **Use Cases**:
    *   **Centralized Policy Management (UC-3, UC-8, UC-11)**: Allows domain policies to be managed separately from domain lifecycle, often by a central security team.
    *   **Granular Access Control (UC-3)**: Defines specific permissions (e.g., `ListRepositoriesInDomain`, `GetAuthorizationToken`, `CreateRepository`) for different IAM principals (users, roles) acting on the domain.
    *   **Cross-Account Access (UC-11)**: Enables granting permissions to principals in other AWS accounts to interact with the domain.
    *   **Post-Creation Configuration**: Apply policies after a domain has been provisioned, potentially by a different process or team.

### Policy Definition Methods

The module offers flexibility in defining the policy content:

1.  **Dynamic Construction**:
    *   Uses inputs: `read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`.
    *   The module internally uses `data "aws_iam_policy_document"` to assemble these inputs into a final JSON policy.
    *   Suitable for defining common access patterns combined with specific custom rules.
2.  **Policy Override**:
    *   Uses input: `policy_document_override`.
    *   If provided, this complete JSON string is used directly, ignoring the dynamic construction inputs.
    *   Suitable when the entire policy is managed externally or has complex logic not easily represented by the dynamic inputs.

### Integration with Other Layers

1.  **Domain Layer**:
    *   Requires `domain_name` and optionally `domain_owner` (outputs from the `domain` module) to identify the target domain.
2.  **Security Layer (IAM)**:
    *   The policy document references IAM principals (users, roles) defined elsewhere in the security layer or AWS environment.

## Implementation Details

*   **Main Resource**: `aws_codeartifact_domain_permissions_policy`
*   **Key Inputs**: `domain_name`, `domain_owner`, `policy_document_override` OR (`read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`), `policy_revision`, `is_enabled`.
*   **Key Outputs**: `policy_revision`, `resource_arn`, `policy_document`.

## Conclusion

The `terraform-aws-codeartifact-domain-permissions` module provides a focused and flexible way to manage the resource-based policy of an existing CodeArtifact domain. It supports both dynamic policy construction and full overrides, enabling centralized and granular control over domain-level access as part of the broader security strategy.
