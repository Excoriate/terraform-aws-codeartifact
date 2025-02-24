# Terraform Module StyleGuide: Mandatory Design and Implementation Rules

## Core Ruleset: Specific Module Development Principles

### Rule: Module Design Philosophy
1. **Enforce Modular Boundaries**: Ensure each module has a singular, well-defined purpose
2. **Maximize Reusability**: Design modules to be adaptable across different infrastructure contexts
3. **Minimize External Dependencies**: Strictly limit and explicitly manage module dependencies
4. **Guarantee Module Isolation**: Create modules that can be used independently with minimal configuration
5. **Support Comprehensive Customization**: Provide extensive configuration options through well-defined variables

## Styleguide: Module Structure Rules

### Rule: Mandatory Module Directory Layout

**Requirement**: Strictly adhere to the following module structure:

```text
/modules/[module-name]/
├── main.tf          # Primary resource definitions
├── locals.tf        # Complex computations and transformations
├── data.tf          # External data source retrieval
├── variables.tf     # Input variable definitions
├── outputs.tf       # Module output definitions
├── versions.tf      # Provider and Terraform version constraints
├── providers.tf     # Optional provider configurations
├── README.md        # Comprehensive module documentation
└── examples/        # Usage examples
    ├── basic/       # Minimal configuration example
    └── complete/    # Full-featured configuration example
```

### Rule: Provider Configuration Guidelines
- If it's a child module, don't create the `providers.tf` file.
- If it's an example module in the `examples/` directory, create the `providers.tf` file, as these are considered root modules.

## Styleguide: Module-Specific Variable Management Rules

### Rule: Variable Definition Guidelines

**Mandatory Module-Specific Requirements**:
- Define all variables exclusively in `variables.tf`. Never create variables in the `main.tf` file.
- Create a `var.is_enabled` variable to enable/disable the entire module.
- When dealing with cloud providers that support tagging (like AWS), always create a `tags` variable.
- Provide comprehensive, continuous descriptions that explain the purpose, impact, and usage of the variable.
- Implement strict type constraints and validation blocks.
- Use `is_*_enabled` naming convention for feature flags (e.g., `is_kms_key_enabled`, `is_log_group_enabled`).

#### Rule: Module-Specific Variable Examples

```hcl
variable "is_enabled" {
    description = "Controls whether to create any resources in this module. When set to false, no resources will be created regardless of other variable settings. This is useful for conditional resource creation or temporary resource disablement without removing the module configuration."
    type        = bool
    default     = true
}

variable "kms_key_deletion_window" {
    type        = number
    description = "Specifies the duration in days that AWS KMS waits before permanently deleting the KMS key. This waiting period provides a safeguard against accidental deletion by allowing time for key recovery if needed. The value must be between 7 and 30 days, with a recommended minimum of 7 days to ensure adequate time for key recovery in case of accidental deletion."
    default     = 7

    validation {
        condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
        error_message = "The KMS key deletion window must be between 7 and 30 days."
    }
}

variable "tags" {
    type        = map(string)
    description = "A map of tags to assign to all resources created by this module. These tags will be applied to all resources that support tagging, helping with resource organization, cost allocation, and access control. Tags should follow your organization's tagging strategy and might include values for environment, project, owner, or other relevant categories."
    default     = {}
}
```

### Rule: Feature Flag Naming Convention
**Requirement**: Use the `is_*_enabled` pattern for all feature flags:

```hcl
locals {
    # Feature flags for resource creation
    is_kms_key_enabled    = var.is_enabled
    is_log_group_enabled  = var.is_enabled
    is_s3_bucket_enabled  = var.is_enabled

    # Resource-specific configurations
    kms_key_description = "KMS key for encrypting CodeArtifact artifacts"
}
```

## Styleguide: Module-Specific Resource Configuration Rules

### Rule: Module Dynamic Resource Creation
**Requirement**: Utilize `for_each` and `locals` for managing complex, dynamic module resource generation:

```hcl
locals {
    # Enforce module resource creation based on strict conditions
    create_resources = var.is_enabled && length(var.instance_configurations) > 0
}

resource "aws_instance" "servers" {
    for_each = local.create_resources ? var.instance_configurations : {}

    # Strict module resource configuration enforcement
    instance_type = each.value.type
    tags = merge(var.tags, {
        Name = "server-${each.key}"
    })
}
```

## Styleguide: Module-Specific Output Design Rules

### Rule: Module Output Generation
**Mandatory Guidelines**:
- Provide comprehensive, meaningful module outputs
- Include critical module resource information
- Support complex output structures
- Ensure outputs provide clear module usage insights

```hcl
output "module_instance_details" {
    description = "Comprehensive module instance information with strict validation"
    value = {
        ids         = { for k, instance in aws_instance.servers : k => instance.id }
        private_ips = { for k, instance in aws_instance.servers : k => instance.private_ip }
        public_ips  = { for k, instance in aws_instance.servers : k => instance.public_ip }
    }
}
```

## Styleguide: Module-Specific Anti-Pattern Prevention Rules

### Prohibited Module Design Practices
- **Reject**: Creating modules with excessive, unrelated responsibilities
- **Prohibit**: Hardcoding environment-specific values within modules
- **Forbid**: Developing modules with overly complex, nested structures
- **Prevent**: Creating modules that are either too generic or too narrowly scoped

## Continuous Module Improvement Guidelines
- **Mandate**: Regular, comprehensive module design reviews
- **Require**: Continuous, constructive team feedback on module implementations
- **Enforce**: Staying current with Terraform module best practices
- **Establish**: A curated library of rigorously tested, highly reusable modules
