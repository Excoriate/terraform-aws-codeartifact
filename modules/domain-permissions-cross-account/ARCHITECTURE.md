# Terraform AWS CodeArtifact Domain Permissions Cross-Account Module: Architecture

## 1. Introduction

This document outlines the architecture and purpose of the `domain-permissions-cross-account` Terraform module. This module facilitates secure, controlled access to an AWS CodeArtifact domain from principals (specifically IAM roles) residing in different AWS accounts. It achieves this by creating a dedicated IAM role within the CodeArtifact domain owner's account, which external principals can assume.

## 2. Architectural Context

This module operates within a multi-account AWS environment where a CodeArtifact domain exists in one account (the "Owner Account") and needs to be accessed by IAM roles in one or more other accounts (the "External Account(s)").

```mermaid
graph TD
    subgraph Owner Account
        direction LR
        Domain(CodeArtifact Domain<br>`var.domain_arn`)
        subgraph "Module Resources"
            XARole(IAM Role<br>`var.role_name`) -- Attached Policy --> PermPolicy(IAM Policy<br>`var.allowed_actions` on Domain)
            XARole -- Trust Policy --> ExternalRoleRef(External Principal(s)<br>`var.external_principals`)
        end
        PermPolicy -.-> Domain
    end

    subgraph External Account(s)
        ExternalRole(External IAM Role<br>`var.external_principals`)
    end

    ExternalRole -- Assumes --> XARole

    style Owner Account fill:#f9f,stroke:#333,stroke-dasharray: 5 5
    style External Account(s) fill:#ccf,stroke:#333,stroke-dasharray: 5 5
    style Domain fill:#FFD700,stroke:#333;
    style XARole fill:#FF9900,stroke:#232F3E,color:#232F3E;
    style PermPolicy fill:#FF9900,stroke:#232F3E,color:#232F3E;
    style ExternalRole fill:#9cf,stroke:#333;
```

**Flow:**

1.  The module provisions an `IAM Role` (`XARole`) in the **Owner Account**.
2.  A **Trust Policy** is attached to this role, explicitly listing the external IAM roles (`ExternalRole`) from other accounts (`var.external_principals`) that are permitted to assume `XARole`.
3.  A **Permissions Policy** (`PermPolicy`) is attached to `XARole`, granting it the specific CodeArtifact actions (`var.allowed_actions`) on the target CodeArtifact Domain (`var.domain_arn`) within the Owner Account.
4.  An IAM Role in an **External Account** uses AWS STS (`AssumeRole`) to assume `XARole` in the Owner Account.
5.  Once assumed, the external principal operates with the permissions defined in `PermPolicy`, allowing it to interact with the CodeArtifact Domain.

## 3. Key Components Created

*   **`aws_iam_role` (`this`):**
    *   **Purpose:** Acts as the secure entry point for cross-account access. External principals assume this role to interact with the CodeArtifact domain.
    *   **Trust Policy:** Defined by `data.aws_iam_policy_document.trust`, which dynamically populates the `Principal` block with the ARNs constructed from `var.external_principals`. This policy explicitly dictates *who* can assume the role.
    *   **Account:** Created in the AWS account where the Terraform configuration is applied (assumed to be the domain owner's account).

*   **`aws_iam_role_policy` (`this`):**
    *   **Purpose:** Defines *what* actions the assumed role (`aws_iam_role.this`) can perform on the specified CodeArtifact domain.
    *   **Permissions:** Defined by `data.aws_iam_policy_document.permissions`, which uses `var.allowed_actions` and `var.domain_arn`. This policy grants the necessary permissions (e.g., `codeartifact:GetAuthorizationToken`, `codeartifact:ListRepositoriesInDomain`) directly on the target domain ARN.
    *   **Attachment:** Attached as an inline policy to `aws_iam_role.this`.

## 4. Use Cases

*   **Centralized CodeArtifact Domain:** Allow development teams, CI/CD pipelines, or build systems residing in separate AWS accounts to securely access and retrieve packages from a centrally managed CodeArtifact domain without needing IAM users directly in the domain owner account.
*   **Partner Access:** Grant specific, limited permissions (e.g., read-only access, ability to get auth tokens) to external partners or third-party systems that need to interact with your CodeArtifact domain.
*   **Organizational Structure:** Support organizational structures where different business units or environments operate in distinct AWS accounts but need shared access to common software artifacts.

## 5. Permissions Model

The module implements access control through two distinct IAM policy documents:

1.  **Trust Policy (Assume Role Policy):** Attached to the created IAM role (`aws_iam_role.this`). It defines *who* (which external IAM role principals specified in `var.external_principals`) is allowed to assume this role using `sts:AssumeRole`.
2.  **Permissions Policy (Inline Role Policy):** Attached to the created IAM role (`aws_iam_role.this`). It defines *what* actions (specified in `var.allowed_actions`) the role can perform *after* it has been assumed, specifically targeting the CodeArtifact domain ARN (`var.domain_arn`).

Access is granted only if an external principal is listed in the trust policy *and* attempts an action permitted by the permissions policy.

## 6. Configuration Highlights

*   `domain_arn`: Specifies the target CodeArtifact domain.
*   `role_name`: Defines the name of the intermediary role created in the owner account.
*   `external_principals`: A list identifying the exact IAM roles in other accounts that are trusted to assume the intermediary role.
*   `allowed_actions`: A list defining the precise CodeArtifact permissions granted to the assumed role.

## 7. Security Considerations

*   **Least Privilege:** Carefully define the `allowed_actions`. Only grant the minimum permissions necessary for the external principals' tasks (e.g., grant `codeartifact:GetAuthorizationToken` and read permissions, but not publish or delete permissions unless explicitly required).
*   **Trust Policy Specificity:** Ensure the `external_principals` list only contains trusted and necessary role ARNs. Avoid wildcards.
*   **Role Naming:** Use a clear and descriptive `role_name` that indicates its cross-account purpose.
*   **Auditing:** Monitor CloudTrail logs in both the owner and external accounts for `sts:AssumeRole` events and CodeArtifact actions performed using the cross-account role.
