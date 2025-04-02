# Makefile for Repository - Basic Example
# This file provides quick commands for testing the module with different fixtures

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled \
        apply-default apply-disabled \
        destroy-default destroy-disabled \
        cycle-default cycle-disabled \
        clean

# Default target when just running 'make'
help:
	@echo "Repository - Basic Example"
	@echo ""
	@echo "Usage: make <target> [AWS_REGION=your-region]"
	@echo "Self-contained example that creates both domain and repository"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                     - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default             - Plan with default configuration (domain and repository)"
	@echo "  make plan-disabled            - Plan with module entirely disabled (no resources created)"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default            - Apply default configuration"
	@echo "  make apply-disabled           - Apply with module disabled"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default          - Destroy default resources"
	@echo "  make destroy-disabled         - Destroy (no-op) with module disabled"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default            - Run full cycle with default configuration"
	@echo "  make cycle-disabled           - Run full cycle with module disabled"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                    - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION                    - AWS region to deploy resources (default: us-west-2)"

# Initialize Terraform
init:
	@echo "Initializing Terraform in $(CURDIR)..."
	terraform init

# Plan commands
plan-default: init
	@echo "Planning with default fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars
plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files in $(CURDIR)..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
