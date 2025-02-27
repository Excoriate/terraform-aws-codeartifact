# Default Module Tests

This directory contains tests for the default module of the terraform-aws-codeartifact repository, following the guidelines specified in the [Terraform Terratest StyleGuide](../../../docs/terraform-styleguide/terraform-styleguide-terratest.md).

## Test Structure

The tests are organized into the following directories:

- `unit/`: Contains unit tests that verify the basic functionality of the default module without creating real resources
  - Read-only tests (with `readonly` build tag) for static analysis
  - Regular unit tests for module configuration validation
- `integration/`: Contains integration tests that create real AWS resources to verify the module's behavior in an actual environment
  - End-to-end (e2e) tests that apply Terraform configurations and validate resources
- `target/`: Contains target-specific Terraform configurations for testing specific use cases
  - Basic configuration for standard module testing

## Test Naming Conventions

All test files follow the naming convention: `[test-target]_[test-name]_[test-scope]_[test-type]_test.go`

Examples:
- `module_default_ro_unit_test.go`: Read-only unit test for the default module
- `example_basic_ro_unit_test.go`: Read-only unit test for the basic example
- `example_basic_unit_test.go`: Unit test for the basic example
- `target_basic_unit_test.go`: Unit test for the basic target
- `example_basic_e2e_test.go`: End-to-end integration test for the basic example
- `target_basic_e2e_test.go`: End-to-end integration test for the basic target

## Running Tests

### Prerequisites

- Go 1.20 or higher
- Terraform 1.5.0 or higher
- AWS credentials with appropriate permissions

### Running Unit Tests

The unit tests perform static analysis and verification of the default module without creating any real AWS resources:

```bash
# Run all unit tests
just tf-tests-unit default

# Run only read-only unit tests
just tf-tests-unit-ro default
```

### Running Integration Tests

The integration tests create real AWS resources to verify the module's functionality:

```bash
# Use a specific AWS profile (optional)
export AWS_PROFILE=your-profile

# Run the integration tests
just tf-tests-integration default
```

### Generating Test Documentation

You can generate documentation and cheat sheets for the tests:

```bash
# Generate documentation for unit tests
just tf-tests-unit-docs default

# Generate documentation for integration tests
just tf-tests-integration-docs default

# Create a cheat sheet for unit tests
just tf-tests-unit-cheatsheet default

# Create a cheat sheet for integration tests
just tf-tests-integration-cheatsheet default

# Run a comprehensive test suite with documentation and cheat sheets
just tf-tests-full default
```

**Note**: The integration tests will create real AWS resources and may incur costs. These resources will be destroyed after the tests complete, but be aware of the potential charges.

## Test Details

### Unit Tests

- `module_default_ro_unit_test.go`: Performs basic sanity checks on the default module code
- `example_basic_ro_unit_test.go`: Tests the basic example configuration without applying
- `example_basic_unit_test.go`: Tests the basic example with Terraform plan
- `target_basic_unit_test.go`: Tests the target configuration with Terraform plan

### Integration Tests

- `example_basic_e2e_test.go`: Creates real AWS resources based on the basic example and validates the outputs
- `target_basic_e2e_test.go`: Creates real AWS resources based on the target configuration and validates the outputs

### Target Configurations

The `target/` directory contains specific Terraform configurations used for testing:

- `basic/`: A minimal configuration that demonstrates the core functionality of the module
  - Used by both unit and integration tests to verify module behavior

## Test Functions

Test functions follow the naming pattern: `Test<Behaviour>On<Scenario>When<Condition>`

Examples:
- `TestInitializationOnModuleWhenUpgradeEnabled`
- `TestValidationOnExamplesWhenBasicConfigurationLoaded`
- `TestPlanningOnExamplesWhenModuleEnabled`
- `TestConfigurationOnTargetWhenModuleEnabled`
- `TestConfigurationOnTargetWhenModuleDisabled`
- `TestDeploymentOnExampleWhenBasicConfigurationApplied`
- `TestDeploymentOnTargetWhenBasicConfigurationApplied`

## Troubleshooting

If you encounter issues with the tests:

1. Ensure your AWS credentials are properly configured
2. Check that you have the necessary permissions to create the required resources
3. Verify that the module path in the tests is correct
4. Make sure you're running the tests from the `tests` directory

If resources are not properly cleaned up, you may need to manually remove them from your AWS account. 

## Running Tests in Nix Environment

For reproducible test execution, you can use the Nix environment:

```bash
# Run unit tests in Nix environment
just tf-tests-unit-nix default

# Run read-only unit tests in Nix environment
just tf-tests-unit-ro-nix default
```
