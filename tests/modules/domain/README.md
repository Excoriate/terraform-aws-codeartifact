# Domain Module Terratest Suite

## Overview

This directory contains terratest test files for the AWS CodeArtifact Domain module. The tests validate both the module's configuration and functional behavior across different scenarios.

## Test Organization

The tests are organized into two main categories:

1. **Example Tests**: Located in the `/examples` directory, these tests validate the examples provided with the module, ensuring they correctly demonstrate the module's functionality.

2. **Unit Tests**: (Not yet implemented) Will be located in the `/unit` directory, these tests validate specific aspects of the module's functionality.

## Test Files

### Example Tests

The example tests validate the examples provided with the module, with both read-only tests (which validate configuration without applying resources) and integration tests (which validate the full deployment lifecycle).

#### Read-Only Tests

- `all_recipes_ro_test.go`: Validates multiple configuration scenarios using different fixtures
  - Checks Terraform plan generation for various configurations
  - Verifies resource creation based on fixture variations
  - Scenarios include:
    * Default configuration
    * Module disabled
    * No encryption
    * Domain permissions
    * Custom domain owner
    * Combined features

#### Integration Tests

- `default_integration_test.go`: Tests the full deployment of the default example
  - Validates resource creation when module is enabled
  - Verifies `is_enabled` output is `true`
  - Performs full Terraform lifecycle (init, plan, apply)

- `disabled_integration_test.go`: Tests the deployment of the disabled module configuration
  - Ensures no resources are created when module is disabled
  - Verifies `is_enabled` output is `false`
  - Validates Terraform plan shows no resource creation

## Running Tests

### Prerequisites

1. Go 1.24 or later installed
2. Terraform 1.10.0 or later installed
3. AWS credentials configured with appropriate permissions

### Running Read-Only Tests

Read-only tests validate configuration without deploying actual resources to AWS:

```bash
# Run all read-only example tests
cd tests
go test -v -timeout 30m -tags=readonly,examples ./modules/domain/examples

# Run a specific read-only test
cd tests
go test -v -timeout 30m -tags=readonly,examples -run=TestPlanningOnDomainExampleWhenAllRecipesAreUsed ./modules/domain/examples
```

### Running Integration Tests

Integration tests deploy actual resources to AWS, validate them, and then destroy them:

```bash
# Run all integration example tests
cd tests
go test -v -timeout 30m -tags=integration,examples ./modules/domain/examples

# Run a specific integration test
cd tests
go test -v -timeout 30m -tags=integration,examples -run=TestDeploymentOnDomainExampleWhenDefaultFixture ./modules/domain/examples
```

**Note**: Integration tests will create actual AWS resources and may incur charges. Resources are destroyed at the end of each test, but in case of test failures, manual cleanup may be required.

## Test Scenarios

The tests validate the domain module's behavior across different scenarios:

1. **Default**: Module enabled with standard configuration
2. **Disabled**: Module entirely disabled (no resources created)
3. **No Encryption**: Domain created without custom encryption
4. **Domain Permissions**: Adding domain-level permissions policy
5. **Custom Domain Owner**: Specifying a custom domain owner
6. **Combined Features**: Multiple configuration options simultaneously

These scenarios match the fixtures in the `examples/domain/basic/fixtures` directory.

## Fixture Variations

The test suite uses multiple fixtures to comprehensively validate the module:

- `default.tfvars`: Standard module configuration
- `disabled.tfvars`: Module completely disabled
- `no-encryption.tfvars`: Domain without custom encryption
- `with-domain-permissions.tfvars`: Adding domain permissions policy
- `custom-domain-owner.tfvars`: Specifying a custom domain owner
- `combined-features.tfvars`: Multiple configuration options

## Best Practices

- Tests are designed to be parallel and independent
- Isolated provider cache prevents interference between tests
- Comprehensive cleanup ensures no lingering resources
- Detailed logging provides clear test execution context

## Troubleshooting

- Ensure AWS credentials are correctly configured
- Check network connectivity
- Verify Terraform and Go versions match
