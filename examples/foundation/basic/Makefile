# Makefile for AWS CodeArtifact Foundation Basic Example
# This file provides quick commands for testing the foundation module

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init plan-default plan-disabled apply-default apply-disabled destroy-default destroy-disabled clean

# Default target when just running 'make'
help:
	@echo "AWS CodeArtifact Foundation Module - Basic Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init               - Initialize Terraform"
	@echo "  make plan-default       - Run terraform plan with default fixture (module enabled)"
	@echo "  make plan-disabled      - Run terraform plan with disabled fixture (module disabled)"
	@echo "  make apply-default      - Run terraform apply with default fixture (module enabled)"
	@echo "  make apply-disabled     - Run terraform apply with disabled fixture (module disabled)"
	@echo "  make destroy-default    - Run terraform destroy with default fixture (module enabled)"
	@echo "  make destroy-disabled   - Run terraform destroy with disabled fixture (module disabled)"
	@echo "  make cycle-default      - Run plan, apply, and destroy with default fixture"
	@echo "  make cycle-disabled     - Run plan, apply, and destroy with disabled fixture"
	@echo "  make clean              - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION              - AWS region to deploy resources (default: us-west-2)"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan with default fixture (module enabled)
plan-default: init
	@echo "Planning with default fixture (module enabled)..."
	terraform plan -var-file=fixtures/default.tfvars

# Plan with disabled fixture (module disabled)
plan-disabled: init
	@echo "Planning with disabled fixture (module disabled)..."
	terraform plan -var-file=fixtures/disabled.tfvars

# Apply with default fixture (module enabled)
apply-default: init
	@echo "Applying with default fixture (module enabled)..."
	terraform apply -var-file=fixtures/default.tfvars -auto-approve

# Apply with disabled fixture (module disabled)
apply-disabled: init
	@echo "Applying with disabled fixture (module disabled)..."
	terraform apply -var-file=fixtures/disabled.tfvars -auto-approve

# Destroy with default fixture (module enabled)
destroy-default: init
	@echo "Destroying resources with default fixture (module enabled)..."
	terraform destroy -var-file=fixtures/default.tfvars -auto-approve

# Destroy with disabled fixture (module disabled)
destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module disabled)..."
	terraform destroy -var-file=fixtures/disabled.tfvars -auto-approve

# Run full cycle with default fixture (plan, apply, destroy)
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"

# Run full cycle with disabled fixture (plan, apply, destroy)
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
