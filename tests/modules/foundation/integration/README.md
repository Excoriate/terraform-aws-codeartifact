# Foundation Module Integration Tests

This directory contains integration tests for the foundation module. These tests deploy real infrastructure to AWS and validate that the resources are created correctly.

## Prerequisites

- AWS credentials configured with appropriate permissions
- Go 1.20 or later
- Terraform 1.5.0 or later

## Running the Tests

### Run all tests

```bash
cd tests
go test -v ./modules/foundation/integration/...
```

### Skip integration tests (useful for CI)

```bash
cd tests
go test -v ./... -short
```

## Test Descriptions

### Module Tests

- `TestKMSKeyCreationAndDeletion`: Validates that a KMS key is created, properly configured with key rotation enabled, and can be deleted.
- `TestS3BucketCreationAndDeletion`: Validates that an S3 bucket is created, properly configured with versioning enabled, and can be deleted.

### Example Tests

- `TestBasicExampleDeployment`: Validates that the basic example can be deployed to AWS and creates a CodeArtifact domain.
- `TestCompleteExampleDeployment`: Validates that the complete example can be deployed to AWS and creates both a CodeArtifact domain and repository.

## Test Design Principles

1. **Reliability**: Tests use unique resource names to avoid conflicts and ensure idempotency.
2. **Cleanup**: All tests use `defer terraform.Destroy()` to clean up resources even if tests fail.
3. **Validation**: Tests validate actual AWS resource state using the AWS SDK v2.
4. **Parallel Execution**: Tests run in parallel for efficiency.
5. **Skip in Short Mode**: Tests can be skipped in short mode for faster CI runs.

## Adding New Tests

When adding new tests, follow these guidelines:

1. Use the AWS SDK v2 for validation
2. Generate unique resource names using timestamps
3. Always clean up resources with `defer terraform.Destroy()`
4. Add descriptive assertions with clear error messages
5. Document new tests in this README 
