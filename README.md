<h1 align="center">
  <img alt="logo" src="https://forum.huawei.com/enterprise/en/data/attachment/forum/202204/21/120858nak5g1epkzwq5gcs.png" width="224px"/><br/>

[![🧼 Pre-commit Hooks](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/pre-commit.yml) [![📚 Terraform Modules CI](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/tf-modules-ci.yaml/badge.svg)](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/tf-modules-ci.yaml) [![🦫 Go Code Quality Checks](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/go-linter.yaml/badge.svg)](https://github.com/Excoriate/terraform-aws-codeartifact/actions/workflows/go-linter.yaml)
---

## Terraform AWS CodeArtifact Module

A comprehensive suite of Terraform modules for deploying and managing AWS CodeArtifact resources, providing a complete package management solution for your organization.

> [!TIP]
> AWS CodeArtifact is a fully managed artifact repository service that makes it easy for organizations to securely store, publish, and share software packages used in their software development process.

### Features

This is a collection of modules that provides:

- 🚀 Complete AWS CodeArtifact infrastructure as code
- 🔒 Secure, encrypted package management with KMS integration
- 🏗️ Modular architecture allowing selective component deployment
- 📦 Support for multiple package formats (npm, Maven, PyPI, etc.)
- 🔄 Repository chaining with upstream repositories and external connections
- 🔐 Fine-grained access control with IAM policies

## Available Modules

| Module Name | Description | Examples | Documentation |
|-------------|-------------|----------|---------------|
| [domain](./modules/domain) | Creates and manages AWS CodeArtifact domains, the fundamental organizational container for repositories | [Basic](./examples/domain/basic) | [AWS CodeArtifact Domain](./docs/terraform-resources/aws_codeartifact_domain%20%20Resources%20%20hashicorpaws%20%20Terraform%20%20Terraform%20Registry.md) |
| [domain-permissions](./modules/domain-permissions) | Manages permissions policies for AWS CodeArtifact domains | [Basic](./examples/domain-permissions) | [AWS CodeArtifact Domain Permissions Policy](./docs/terraform-resources/aws_codeartifact_domain_permissions_policy%20%20Resources%20%20hashicorpaws%20%20Terraform%20%20Terraform%20Registry.md) |
| [repository](./modules/repository) | Creates and manages AWS CodeArtifact repositories with support for upstream repositories and external connections | [Basic](./examples/repository) | [AWS CodeArtifact Repository](./docs/terraform-resources/aws_codeartifact_repository%20%20Resources%20%20hashicorpaws%20%20Terraform%20%20Terraform%20Registry.md) |
| [repository-permissions](./modules/repository-permissions) | Manages permissions policies for AWS CodeArtifact repositories | [Basic](./examples/repository-permissions) | [AWS CodeArtifact Repository Permissions Policy](./docs/terraform-resources/aws_codeartifact_repository_permissions_policy%20%20Resources%20%20hashicorpaws%20%20Terraform%20%20Terraform%20Registry.md) |
| [foundation](./modules/foundation) | Provisions foundational resources required for AWS CodeArtifact operations (KMS keys, CloudWatch logs, S3 buckets) | [Basic](./examples/foundation) | [Foundation Resources](./docs/terraform-resources/terraform-aws-codeartifact-foundation-resources.md) |
| [default](./modules/default) | Combines all modules to create a complete AWS CodeArtifact setup | [Basic](./examples/default) | All of the above |

### Usage

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Documentation References

- **Tests** (`/tests`):
  - [Testing Overview and Guidelines](/tests/README.md)
  - Comprehensive infrastructure testing using Terratest
  - Includes unit, integration, and validation tests

- **Scripts** (`/scripts`):
  - [Development Utilities and Workflow](/scripts/README.md)
  - Helper scripts for Git hooks, repository maintenance
  - Standardized development process automation

- **Modules** (`/modules`):
  - [Module Development Guidelines](/modules/README.md)
  - [Terraform Modules StyleGuide](/docs/terraform-styleguide/terraform-styleguide-modules.md)
  - Reusable, well-structured Terraform module implementations

- **Examples** (`/examples`):
  - [Module Usage Examples](/examples/README.md)
  - Practical configurations demonstrating module usage
  - Progressive complexity from basic to advanced scenarios

- **Docs** (`/docs`):
  - [Developer Tools Guide](/docs/guides/development-tools-guide.md)
  - Terraform StyleGuide:
    - [Code Guidelines](/docs/terraform-styleguide/terraform-styleguide-code.md)
    - [Modules Guidelines](/docs/terraform-styleguide/terraform-styleguide-modules.md)
    - [Examples Guidelines](/docs/terraform-styleguide/terraform-styleguide-examples.md)
    - [Terratest Guidelines](/docs/terraform-styleguide/terraform-styleguide-terratest.md)
  - [Project Roadmap](/docs/ROADMAP.md)
  - Comprehensive project documentation and future plans

**📘 Additional Resources:**
- [Contribution Guidelines](CONTRIBUTING.md)
- [Terraform Registry Module Best Practices](/docs/terraform-styleguide/terraform-styleguide-modules.md)
