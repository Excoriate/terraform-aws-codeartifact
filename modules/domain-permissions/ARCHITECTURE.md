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

The module determines the final policy document (`local.final_policy_document`) using the following logic:

1.  **Policy Override (Highest Precedence)**:
    *   If `var.policy_document_override` is provided (not `null`), its value is used directly as the final policy document.
    *   All dynamic construction inputs (`read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`) are ignored in this case.
    *   Suitable when the entire policy is managed externally or requires complex structure beyond the dynamic inputs.

2.  **Dynamic Construction (Used if Override is `null`)**:
    *   If `var.policy_document_override` is `null`, the module attempts to construct a policy using the `data "aws_iam_policy_document" "combined"` data source.
    *   This data source is evaluated *only* if `var.is_enabled` is true and `var.policy_document_override` is `null`.
    *   The constructed policy *always* includes a default statement (`Sid = "DefaultOwnerReadDomainPolicy"`) granting the domain owner (the AWS account executing Terraform) `codeartifact:GetDomainPermissionsPolicy` and `codeartifact:ListRepositoriesInDomain` permissions on the domain.
    *   It *conditionally* adds further statements based on the provided principal lists:
        *   If `var.read_principals` is provided, a statement granting `codeartifact:GetDomainPermissionsPolicy` is added.
        *   If `var.list_repo_principals` is provided, a statement granting `codeartifact:ListRepositoriesInDomain` is added.
        *   If `var.authorization_token_principals` is provided, a statement granting `codeartifact:GetAuthorizationToken` and `sts:GetServiceBearerToken` is added.
        *   If `var.custom_policy_statements` is provided, each statement object in the list is added.
    *   The resulting JSON from this data source becomes the final policy document.
    *   Suitable for defining common access patterns combined with specific custom rules, ensuring a minimal valid policy even with few inputs.

### Resource Creation Condition

The `aws_codeartifact_domain_permissions_policy` resource itself is created (`count = 1`) based on the `local.create_policy` flag, which requires:
*   `var.is_enabled` must be `true`.
*   AND *either* `var.policy_document_override` must be provided, *or* at least one of the dynamic construction inputs (`read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`) must be provided (i.e., not null/empty). If only the default statement would be generated, the policy resource is *not* created unless explicitly triggered by one of these inputs or the override. *(Self-correction during thought: The `local.create_policy` logic was updated. It creates if override is set OR if `has_baseline_inputs` is true. `has_baseline_inputs` checks if any of the dynamic lists have length > 0. So, if only defaults are used and no dynamic inputs are provided, `create_policy` is false, and no policy resource is created unless override is used. This needs clarification.)*

**Correction:** The `aws_codeartifact_domain_permissions_policy` resource itself is created (`count = 1`) based on the `local.create_policy` flag. This flag is true if:
*   `var.is_enabled` is true.
*   AND *either*:
    *   `var.policy_document_override` is provided (not `null`).
    *   OR at least one of the dynamic construction inputs (`read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`) has a non-empty list provided (`local.has_baseline_inputs` is true).
*   **Note:** If `var.is_enabled` is true but `policy_document_override` is `null` and all dynamic input lists are empty, the policy resource will *not* be created, even though the data source *would* generate a default policy if evaluated.

### Integration with Other Layers

1.  **Domain Layer**:
    *   Requires `domain_name` and optionally `domain_owner` (outputs from the `domain` module) to identify the target domain.
2.  **Security Layer (IAM)**:
    *   The policy document references IAM principals (users, roles) defined elsewhere in the security layer or AWS environment.

## Implementation Details

*   **Main Resource**: `aws_codeartifact_domain_permissions_policy`
*   **Key Inputs**: `is_enabled`, `domain_name`, `domain_owner`, `policy_document_override`, `read_principals`, `list_repo_principals`, `authorization_token_principals`, `custom_policy_statements`, `policy_revision`.
*   **Key Logic**: `local.create_policy`, `local.final_policy_document`, `data.aws_iam_policy_document.combined`.
*   **Key Outputs**: `policy_revision`, `resource_arn`, `policy_document`.

## Conclusion

The `terraform-aws-codeartifact-domain-permissions` module provides a focused and flexible way to manage the resource-based policy of an existing CodeArtifact domain. It supports both dynamic policy construction and full overrides, enabling centralized and granular control over domain-level access as part of the broader security strategy.
