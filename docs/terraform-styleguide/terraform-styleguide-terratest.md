# Terraform Terratest StyleGuide: Mandatory Testing Standards and Practices

## Table of Contents

- [Terraform Terratest StyleGuide: Mandatory Testing Standards and Practices](#terraform-terratest-styleguide-mandatory-testing-standards-and-practices)
  - [Table of Contents](#table-of-contents)
  - [Purpose and Scope](#purpose-and-scope)
  - [Styleguide: Fundamental Principles of Terraform Testing](#styleguide-fundamental-principles-of-terraform-testing)
    - [Rule: Testing Philosophy](#rule-testing-philosophy)
    - [Rule: Type of Tests](#rule-type-of-tests)
    - [Rule: Test Targets](#rule-test-targets)
    - [Rule: Test Naming Conventions](#rule-test-naming-conventions)
  - [Styleguide: Test Structure Rules](#styleguide-test-structure-rules)
    - [Rule: Test Directory Layout](#rule-test-directory-layout)
    - [Rule: Golang Styleguide for terratest test files](#rule-golang-styleguide-for-terratest-test-files)
    - [Rule: Target Terraform Configuration (or modules) in the Test Directory](#rule-target-terraform-configuration-or-modules-in-the-test-directory)
    - [Rule: Test File Creation, and Organization.](#rule-test-file-creation-and-organization)
  - [Styleguide: Unit Testing Rules](#styleguide-unit-testing-rules)
    - [Rule: Module Unit Tests](#rule-module-unit-tests)
  - [Styleguide: Test Implementation Rules](#styleguide-test-implementation-rules)
    - [Rule: Terratest Rules](#rule-terratest-rules)
  - [Styleguide: Test Utilities](#styleguide-test-utilities)
    - [Rule: Repository Path Resolution](#rule-repository-path-resolution)
  - [Styleguide: Test Execution Rules](#styleguide-test-execution-rules)
    - [Rule: Using Justfile Commands](#rule-using-justfile-commands)

## Purpose and Scope

This document provides comprehensive guidelines for implementing tests for Terraform modules using Terratest, ensuring consistent, reliable, and maintainable test suites that validate module functionality and serve as executable documentation.

## Styleguide: Fundamental Principles of Terraform Testing

### Rule: Testing Philosophy

- ENSURE tests validate both resource creation and configuration of the target module.
- ALWAYS the tests validate the two dimension when creating IaaC with Terraform: 1) the module's configuration, and 2) the module's features.
  - The module's configuration: Is the module returning the expected plan output under certain conditions? is the module's output the one expected? are the resources created?
  - The module's features: Is the module's feature working as expected? Are the resources created with the declared configuration and reflect as such in the provider's API?
- ALWAYS use the latest version of Terratest, and the latest version of Terraform.
- ALWAYS check, and refresh your memory reading these guidelines, and the [Terratest](https://terratest.gruntwork.io/) documentation.
- TOTALLY PROHIBITED flaky tests, or tests that are not deterministic.
- ALWAYS integration tests require apply the resources, and test with the provider's API (AWS, GCP, etc.) the actual resources created before they're destroyed.

### Rule: Type of Tests

There are two types of tests based on **their scope**:

1. **Unit Tests**: These tests are used to test the module's configuration and individual features. They are always located in the `tests/[module-name]/unit` directory.
2. **Integration Tests**: These tests are used to test the module's features and example implementations by applying the resources and testing against the provider's API (AWS, GCP, etc.). They are always located in the `tests/[module-name]/integration` directory and must have the `integration` build tag.

There are two types of tests based on **their purpose**:

1. **Read Only**: These tests are used to test the module's configuration and individual features without applying the resources. They are mostly found in the `tests/[module-name]/unit` directory, but there may be cases where they are in the `tests/[module-name]/integration` directory as well. They must have the `readonly` build tag.
2. **e2e**: These tests are used to test the module's features and example implementations by applying the resources and testing against the provider's API (AWS, GCP, etc.). They are primarily located in the `tests/[module-name]/integration` directory and must have the `integration` build tag.

- ALWAYS, the tests under the `tests/[module-name]/unit` directory, MUST have the `unit` build tag.
- ALWAYS, the tests under the `tests/[module-name]/integration` directory, MUST have the `integration` build tag.
- ALWAYS, the tests that aren't applying, or just doing static analysis (like terraform validate, or terraform fmt) MUST have the `readonly` build tag.

### Rule: Test Targets

The test targets are the sources of the terraform configuration files (or modules) that are being tested, and from where the tests [terratest](https://terratest.gruntwork.io/) will be executed against.

- ALWAYS, with no exception, acknowledge the following test targets:

| Test Target (target is where the *.tf files and the modules are located)                                   | Description                                                  | 
|-----------------------------------------------|--------------------------------------------------------------|
| `modules/[module-name]`                       | The main module being tested. Only run tests against this target for static analysis, and read-only tests (terraform init, terraform validate, etc.).                               |
| `examples/[module-name]/basic`                | Example implementation of the module with basic configuration. Suitable for unit tests, and integration tests. |
| `examples/[module-name]/complete`             | Example implementation of the module with complete configuration. Suitable for integration tests |
| `tests/[module-name]/target/[use-case-name]/` | Use-case specific test suite for particular features of the module that's in the `tests/[module-name]/target/` directory. Suitable for unit tests, and integration tests, but mostly unit tests either read-only, or e2e. |

### Rule: Test Naming Conventions

- MANDATORY NAMING CONVENTION: the tests should be named following the pattern: `[test-target]_[test-name]_[test-scope]_test`, where:
  - `[test-target]`: is the target of the test (terraform module) to test. ONLY VALID VALUES are `example`, `module`, `target`.
  - `[test-name]`: is the name of the test that always match the name of the terraform module. The valid values are:
    - `[module-name]` - If the target is the main module being tested in the directory `modules/[module-name]`, then it's the name of the module. E.g.: `mymodule` where the module is in the `modules/mymodule/` directory.
    - `[use-case-name]` - If the target is a use-case in the directory `tests/[module-name]/target/[use-case-name]`, then it's the name of the use-case. E.g.: `enabled_keys` where the use-case is in the `tests/mymodule/target/enabled_keys/` directory.
    - `[example-name]` - If the target is an example module in the directory `examples/[module-name]/[example-name]`, then it's the name of the example. E.g.: `basic` where the example is in the `examples/mymodule/basic/` directory.
  - `[test-scope]`: is the scope of the test - ONLY VALID VALUES ARE `ro`, `` (empty, no value), where no value means that it's omitted for those test files that include integration tests, or tests that perform apply, or destroy.
  - `[test-type]`: is the type of the test - ONLY VALID VALUES ARE `unit`, `e2e`, for unit test, and integration test respectively.

- *Good Examples*:
  - `module_codeartifact_ro_unit_test.go` 
    - **Explanation**: A read-only unit test for the CodeArtifact module itself, focusing on static configuration validation.
    - **Target**: Main module in `modules/codeartifact/`
    - **Scope**: Read-only
    - **Type**: Unit test

  - `example_basic_ro_unit_test.go` 
    - **Explanation**: A read-only unit test for the basic example of the module, checking static configuration and default settings.
    - **Target**: Basic example in `examples/codeartifact/basic/`
    - **Scope**: Read-only
    - **Type**: Unit test

  - `example_complete_e2e_test.go` 
    - **Explanation**: An end-to-end integration test for the complete example, which applies resources and validates their actual creation and configuration.
    - **Target**: Complete example in `examples/codeartifact/complete/`
    - **Scope**: Full integration
    - **Type**: End-to-end test

  - `target_enabled_keys_e2e_test.go` 
    - **Explanation**: An end-to-end integration test for a specific use-case (enabled keys) in the target test directory, which applies resources and validates the specific feature.
    - **Target**: Specific use-case in `tests/codeartifact/target/enabled_keys/`
    - **Scope**: Full integration
    - **Type**: End-to-end test

  - `target_disabled_configuration_ro_unit_test.go`
    - **Explanation**: A read-only unit test for a specific configuration scenario (disabled configuration) in the target test directory, focusing on static validation.
    - **Target**: Specific configuration scenario in `tests/codeartifact/target/disabled_configuration/`
    - **Scope**: Read-only
    - **Type**: Unit test

## Styleguide: Test Structure Rules

### Rule: Test Directory Layout

- FOLLOW this structure for all test implementations:

```text
tests/
├── README.md               # Testing documentation
├── go.mod                  # Go module dependencies
├── go.sum                  # Dependency lockfile
├── pkg/                    # Shared testing utilities
│   └── repo/               # Repository path utilities
│       └── finder.go       # Path resolution functions
└── modules/                # Module-specific test suites
    └── <module_name>/      # Tests for specific module
        ├── target/         # Use-case specific test suite
        │   ├── basic/      # Basic use-case configuration
        │   │   └── main.tf # Terraform configuration for basic use-case
        │   ├── enabled_keys/  # Specific use-case for enabled keys
        │   │   └── main.tf # Terraform configuration for enabled keys use-case
        │   └── disabled_configuration/  # Specific use-case for disabled configuration
        │       └── main.tf # Terraform configuration for disabled configuration use-case
        ├── unit/           # Unit test suite
        │   ├── module_codeartifact_ro_unit_test.go    # Read-only unit tests for the module itself
        │   ├── examples_basic_ro_unit_test.go         # Read-only unit tests for basic example
        │   ├── features_test.go                       # Comprehensive feature unit tests
        │   └── target_disabled_configuration_ro_unit_test.go  # Read-only unit test for specific configuration
        └── integration/    # Integration test suite
            ├── example_complete_e2e_test.go           # End-to-end integration test for complete example
            └── target_enabled_keys_e2e_test.go        # End-to-end integration test for specific use-case
```

- Boilerplate code that's always included in every test implementation:
  - `go.mod` and `go.sum` files, to manage the dependencies, since the Go modules are always created in advance. Always USE THE LATEST VERSION OF GO that's available. Currently, it's `1.24.0`.
  - `pkg/` directory, to manage the shared testing utilities. More utilities shared by all tests will be added incrementally.

### Rule: Golang Styleguide for terratest test files

- STRICTLY adhere to the `.golangci.yml` file, to ensure the test files are well-written, and easy to understand.
- ALWAYS use Go Docs (verbose) for each Test Function, to explain what the test is verifying.
- ALWAYS write common utilities, and helpers in the `pkg/` directory, to be used across all tests.
- USE descriptive variable names
- FOLLOW Go naming conventions, and the Go effective practices.

### Rule: Target Terraform Configuration (or modules) in the Test Directory

The purpose of these configurations is to be used for unit testing purposes.

- ALWAYS create the `tests/modules/[module-name]/target/basic/main.tf`, to manage the terraform configuration for the use-case, that's the most basic, and default one. Mimic the configuration placed in the `examples/[module-name]/basic/main.tf` file, as a good starting point, and reference. Nevertheless, ALSO CHECK the `variables.tf` file, and the `outputs.tf` file, to ensure the use-case is properly configured (from the `modules/[module-name]/variables.tf` and `modules/[module-name]/outputs.tf` files).
- ALWAYS call the first target unit-test module `basic`, so if you're creating a new target unit-test module, name it `tests/modules/[module-name]/target/basic/main.tf`.
- NAME the module reference as `this`, and not `[module-name]_test` in the `tests/modules/[module-name]/target/[use-case-name]/main.tf` file.
- OPTIONALLY, create `variables.tf`, and other `*.tf` configuration files, ONLY if they're required by the unit tests. If the test is simple enough, or a particular feature is required to be tested, it's okay to have only the `main.tf` file in the `tests/modules/[module-name]/target/[use-case-name]/` directory.

### Rule: Test File Creation, and Organization.

- ALWAYS follow the naming convention for the test files, and the test functions, as explained in the [Rule: Test Naming Conventions](#rule-test-naming-conventions) section.
- A Good Example of a test function is (self-explanatory, with nice comments, and verbose):

```go
// TestSanityChecksOnModule verifies that the Terraform module can be initialized and validated successfully.
// It performs the following steps:
// 1. Initializes the Terraform module located in the specified directory.
// 2. Validates the Terraform configuration to ensure it is syntactically valid and ready for deployment.
// This test runs in parallel to allow for efficient execution of multiple tests.
func TestSanityChecksOnModule(t *testing.T) {
	// Parallel execution with unique test names
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Enhanced Terraform options with logging and upgrade
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetModulesDir("default"),
		Upgrade:      true,
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Validate with detailed error output
	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)
}
```

- The unit test functions should be named following the pattern: `Test<Behaviour>On<Scenario>When<Condition>`. E.g.: `TestStaticAnalysisOnExamplesWhenTerraformIsInitialized`, and ensure it's consistent, clear, and ideally short without sacrificing the readability.

```go
// TestInitializationOnModuleWhenUpgradeEnabled verifies that the Terraform module can be successfully initialized
// with upgrade enabled, ensuring compatibility and readiness for deployment.
func TestInitializationOnModuleWhenUpgradeEnabled(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetModulesDir("default"),
		Upgrade:      true,
	}

	t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)
}

// TestValidationOnExamplesWhenBasicConfigurationLoaded ensures that the basic example 
// configuration passes Terraform validation checks, verifying its structural integrity.
func TestValidationOnExamplesWhenBasicConfigurationLoaded(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
	}

	t.Logf("🔍 Terraform Examples Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Validate with detailed error output
	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)

	// Run terraform fmt check
	fmtOutput, err := terraform.RunTerraformCommandAndGetStdoutE(t, terraformOptions, "fmt", "-recursive", "-check")
	require.NoError(t, err, "Terraform fmt failed")
	t.Log("✅ Terraform fmt Output:\n", fmtOutput)
}

// TestPlanningOnExamplesWhenModuleEnabled verifies the Terraform plan generation 
// for the basic example when the module is explicitly enabled.
func TestPlanningOnExamplesWhenModuleEnabled(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	t.Logf("🔍 Terraform Examples Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to show what would be created in examples
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify no changes are planned when module is disabled
	disabledOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
	}

	disabledPlanOutput, err := terraform.PlanE(t, disabledOptions)
	require.NoError(t, err, "Terraform plan failed for disabled module")
	t.Log("📝 Terraform Plan Output (Disabled Module):\n", disabledPlanOutput)

	// Cleanup resources after test
	terraform.Destroy(t, terraformOptions)
}
```



- MAINTAIN consistency with module variable names
- USE lowercase with underscores for all file names
- FOLLOW standard Go test file naming (`*_test.go`)
- ENSURE file names reflect their purpose

## Styleguide: Unit Testing Rules

### Rule: Module Unit Tests

- VERIFY module initialization succeeds
- VALIDATE module structure and configuration
- ENSURE module passes static analysis

```go
func TestSanityChecksOnModule(t *testing.T) {
    t.Parallel()

    dirs, err := repo.NewTFSourcesDir()
    require.NoError(t, err, "Failed to get Terraform sources directory")

    terraformOptions := &terraform.Options{
        TerraformDir: dirs.GetModulesDir("default"),
        Upgrade:      true,
    }

    t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

    initOutput, err := terraform.InitE(t, terraformOptions)
    require.NoError(t, err, "Terraform init failed")

    validateOutput, err := terraform.ValidateE(t, terraformOptions)
    require.NoError(t, err, "Terraform validate failed")
}
```

- TEST module behavior with feature flags enabled and disabled
- VERIFY conditional resource creation works as expected
- VALIDATE module handles edge cases properly
- TEST module with various input combinations
- VERIFY validation rules work as expected
- CONFIRM default values are applied correctly

## Styleguide: Test Implementation Rules

### Rule: Terratest Rules

- IMPLEMENT parallel execution with `t.Parallel()`
- STRUCTURE tests with setup, execution, and validation phases
- INCLUDE detailed logging for troubleshooting

```go
func TestExampleStructure(t *testing.T) {
    // Enable parallel execution
    t.Parallel()

    // Setup phase
    dirs, err := repo.NewTFSourcesDir()
    require.NoError(t, err, "Failed to get Terraform sources directory")

    terraformOptions := &terraform.Options{
        TerraformDir: dirs.GetExamplesDir("default/basic"),
        Vars: map[string]interface{}{
            "is_enabled": true,
        },
    }

    // Log test context
    t.Logf("Testing directory: %s", terraformOptions.TerraformDir)

    // Execution phase
    terraform.InitAndPlan(t, terraformOptions)

    // Validation phase
    // Add assertions here

    // Optional: Cleanup phase
    defer terraform.Destroy(t, terraformOptions)
}
```

- ENSURE each test is independent
- AVOID shared state between tests
- IMPLEMENT proper setup and teardown
- USE `require` package for critical assertions
- IMPLEMENT detailed error messages
- CHOOSE appropriate assertion functions
- CHECK all error returns
- PROVIDE detailed error messages
- USE `require.NoError` for critical operations
- IMPLEMENT proper test cleanup on failure
- LOG detailed information about the failure
- ENSURE tests fail clearly and informatively
- INCLUDE context in error messages
- LOG relevant state information
- PROVIDE actionable error messages
- ENABLE parallel test execution with `t.Parallel()`
- ENSURE tests are independent and can run concurrently
- AVOID shared state that could cause race conditions
- USE unique resource names for parallel tests
- IMPLEMENT random suffixes for resource names
- AVOID resource name collisions

## Styleguide: Test Utilities

### Rule: Repository Path Resolution

- USE the `repo` package for path resolution, and other utilities, and packages that are available in the `pkg/` directory.
- AVOID hardcoded paths, unless it's strictly necessary.

## Styleguide: Test Execution Rules

### Rule: Using Justfile Commands

- USE Justfile commands for test execution
- ALWAYS inspect with `just` the commands that are available, and the options that can be used. For test executions, there are the following commands that are available:

```bash
# Run unit tests for a specific module
just tf-tests-unit default

# Run read-only unit tests for a specific module
just tf-tests-unit-ro default

# Run integration tests for a specific module
just tf-tests-integration default

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

# Run tests in Nix environment
just tf-tests-unit-nix default
just tf-tests-unit-ro-nix default
just tf-tests-integration-nix default
```
