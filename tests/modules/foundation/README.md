# Foundation Module Tests

This directory contains tests for the foundation module of the terraform-aws-codeartifact repository.

## Test Structure

The tests are organized into the following directories:

- `unit`: Contains unit tests that verify the basic functionality of the foundation module without creating real resources
- `target`: Contains target tests that create real AWS resources to verify the module's behavior in an actual environment

## Running Tests

### Prerequisites

- Go 1.14 or higher
- Terraform 0.14 or higher
- AWS credentials with appropriate permissions

### Running Unit Tests

The unit tests perform static analysis and verification of the foundation module without creating any real AWS resources:

```bash
cd tests
go test -v ./modules/foundation/unit/...
```

### Running Target Tests

The target tests create real AWS resources to verify the module's functionality:

```bash
cd tests
# Use a specific AWS profile (optional)
export AWS_PROFILE=your-profile
# Run the target tests
go test -v ./modules/foundation/target/...
```

**Note**: The target tests will create real AWS resources and may incur costs. These resources will be destroyed after the tests complete, but be aware of the potential charges.

## Test Details

### Unit Tests

- `module_test.go`: Performs basic sanity checks on the foundation module code
- `examples_test.go`: Tests the basic example of the foundation module

### Target Tests

- `basic/target_test.go`: Creates real AWS resources based on the basic example and validates the outputs

## Skipping Tests

To skip target tests that create real resources:

```bash
go test -v ./modules/foundation/... -short
```

## Troubleshooting

If you encounter issues with the tests:

1. Ensure your AWS credentials are properly configured
2. Check that you have the necessary permissions to create the required resources
3. Verify that the module path in the tests is correct
4. Make sure you're running the tests from the `tests` directory

If resources are not properly cleaned up, you may need to manually remove them from your AWS account. 
