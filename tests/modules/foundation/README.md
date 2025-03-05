# Foundation Module Terratest Suite

This directory contains terratest test files for the AWS CodeArtifact Foundation module. The tests validate both the module's configuration and functional behavior across different scenarios.

## Test Organization

The tests are organized into two main categories:

1. **Example Tests**: Located in the `/examples` directory, these tests validate the examples provided with the module, ensuring they correctly demonstrate the module's functionality.

2. **Unit Tests**: (Not yet implemented) Will be located in the `/unit` directory, these tests validate specific aspects of the module's functionality.

## Test Files

### Example Tests

The example tests validate the examples provided with the module, with both read-only tests (which validate configuration without applying resources) and integration tests (which validate the full deployment lifecycle).

#### Read-Only Tests

- `basic_readonly_test.go`: Validates the basic example with all components enabled
- `disabled_readonly_test.go`: Validates the example with the module entirely disabled
- `kms_disabled_readonly_test.go`: Validates the example with only the KMS key component disabled
- `s3_disabled_readonly_test.go`: Validates the example with only the S3 bucket component disabled
- `logs_disabled_readonly_test.go`: Validates the example with only the CloudWatch logs component disabled

#### Integration Tests

- `basic_integration_test.go`: Tests the full deployment of the basic example with all components enabled, including validation of AWS resources
- `disabled_integration_test.go`: Tests the deployment of the disabled module configuration, ensuring no resources are created

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
go test -v -timeout 30m -tags=readonly,examples ./modules/foundation/examples

# Run a specific read-only test
cd tests
go test -v -timeout 30m -tags=readonly,examples -run=TestPlanningOnExamplesBasicWhenDefaultFixture ./modules/foundation/examples
```

### Running Integration Tests

Integration tests deploy actual resources to AWS, validate them, and then destroy them:

```bash
# Run all integration example tests
cd tests
go test -v -timeout 30m -tags=integration,examples ./modules/foundation/examples

# Run a specific integration test
cd tests
go test -v -timeout 30m -tags=integration,examples -run=TestDeploymentOnExamplesBasicWhenDefaultFixture ./modules/foundation/examples
```

**Note**: Integration tests will create actual AWS resources and may incur charges. Resources are destroyed at the end of each test, but in case of test failures, manual cleanup may be required.

## Test Scenarios

The tests validate the foundation module's behavior across different scenarios:

1. **Default**: All components enabled (KMS, S3, CloudWatch Logs)
2. **Disabled**: Module entirely disabled (no resources created)
3. **KMS Disabled**: Only the KMS key component disabled
4. **S3 Disabled**: Only the S3 bucket component disabled
5. **Logs Disabled**: Only the CloudWatch logs component disabled

These scenarios match the fixtures in the `examples/foundation/basic/fixtures` directory.
