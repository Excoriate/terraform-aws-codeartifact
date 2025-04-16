# Basic Example: Domain Permissions Cross Account Module

## Overview
> **Note:** This example demonstrates basic usage of the `domain-permissions-cross-account` module. It creates a CodeArtifact domain directly, then uses the module (`module "this"`) to create an IAM role in the current account that *could* be assumed by a placeholder external principal (also using the current account ID for runnability). This role is granted basic permissions (`GetAuthorizationToken`, `DescribeDomain`, `ListRepositoriesInDomain`) on the created domain.

### 🔑 Key Features Demonstrated
- Creating a prerequisite CodeArtifact domain.
- Calling the `domain-permissions-cross-account` module (`module "this"`).
- Configuring the module with a placeholder `external_principals` list (using the current account ID) to make it self-contained and runnable.
- Granting basic domain-level permissions via `allowed_actions`.
- Using fixtures (`fixtures/*.tfvars`) to test enabled/disabled states.

### 📋 Usage Guidelines
1.  **Configure:** Use the `fixtures/default.tfvars` file. For real cross-account usage, you would update the `external_principals` variable with the actual external account ID and role name.
    ```tfvars
    # fixtures/default.tfvars (Example - usually empty to use defaults)
    # external_principals = [{ account_id = "EXTERNAL_ACCOUNT_ID", role_name = "EXTERNAL_ROLE_NAME" }]
    # allowed_actions = ["codeartifact:GetAuthorizationToken"] # Override default actions if needed
    ```
2.  **Initialize:** Run `terraform init`.
3.  **Plan:** Run `terraform plan -var-file=fixtures/default.tfvars`.
4.  **Apply:** Run `terraform apply -var-file=fixtures/default.tfvars`.
5.  **Makefile:** Alternatively, use the provided `Makefile` targets (`make plan-default`, `make apply-default`).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
