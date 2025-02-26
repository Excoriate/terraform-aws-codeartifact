.PHONY: test-unit test-target test-all clean

# Define variables
MODULE_PATH=./modules/foundation
GO_TEST=go test -v

# Run unit tests
test-unit:
	@echo "Running unit tests for foundation module..."
	cd ../.. && $(GO_TEST) $(MODULE_PATH)/unit/...

# Run target tests (creates real AWS resources)
test-target:
	@echo "Running target tests for foundation module (creates real AWS resources)..."
	cd ../.. && $(GO_TEST) $(MODULE_PATH)/target/...

# Run all tests
test-all:
	@echo "Running all tests for foundation module..."
	cd ../.. && $(GO_TEST) $(MODULE_PATH)/...

# Skip tests that create real AWS resources
test-skip-target:
	@echo "Running tests without creating real AWS resources..."
	cd ../.. && $(GO_TEST) $(MODULE_PATH)/... -short

# Clean up any leftover resources
clean:
	@echo "Cleaning up any leftover resources..."
	cd ../.. && terraform init -reconfigure
	cd ../.. && terraform destroy -auto-approve

help:
	@echo "Available targets:"
	@echo "  test-unit         - Run unit tests only (no AWS resources created)"
	@echo "  test-target       - Run target tests (creates real AWS resources)"
	@echo "  test-all          - Run all tests"
	@echo "  test-skip-target  - Run tests without creating real AWS resources"
	@echo "  clean             - Clean up any leftover resources"

# Default target
default: test-unit
