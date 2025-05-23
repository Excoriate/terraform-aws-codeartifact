# Makefile for AWS CodeArtifact Foundation - Advanced OIDC Example
# This file provides quick commands for testing the foundation module with multiple OIDC roles

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-advanced plan-oidc-existing \
        apply-default apply-disabled apply-advanced apply-oidc-existing \
        destroy-default destroy-disabled destroy-advanced destroy-oidc-existing \
        cycle-default cycle-disabled cycle-advanced cycle-oidc-existing \
        clean

# Default target when just running 'make'
help:
	@echo "AWS CodeArtifact Foundation Module - Advanced OIDC Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                 - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default         - Plan with default configuration (OIDC, KMS, S3, Logs disabled)"
	@echo "  make plan-disabled        - Plan with module entirely disabled"
	@echo "  make plan-advanced        - Plan creating OIDC provider and roles (KMS, S3, Logs disabled by default)"
	@echo "  make plan-oidc-existing   - Plan using existing OIDC provider and creating roles (KMS, S3, Logs disabled by default)"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default        - Apply default configuration (No resources created)"
	@echo "  make apply-disabled       - Apply with module entirely disabled (No resources created)"
	@echo "  make apply-advanced       - Apply creating OIDC provider and roles (KMS, S3, Logs disabled by default)"
	@echo "  make apply-oidc-existing  - Apply using existing OIDC provider and creating roles (KMS, S3, Logs disabled by default)"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default      - Destroy default configuration (No resources)"
	@echo "  make destroy-disabled     - Destroy with module entirely disabled (No resources)"
	@echo "  make destroy-advanced     - Destroy OIDC provider and roles created by advanced fixture"
	@echo "  make destroy-oidc-existing- Destroy OIDC roles created by oidc-existing fixture"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default        - Run full cycle with default configuration (No resources created)"
	@echo "  make cycle-disabled       - Run full cycle with module entirely disabled (No resources created)"
	@echo "  make cycle-advanced       - Run full cycle creating OIDC provider and roles"
	@echo "  make cycle-oidc-existing  - Run full cycle using existing OIDC provider and creating roles"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION                - AWS region to deploy resources (default: us-west-2)"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan commands
plan-default: init
	@echo "Planning with default fixture (OIDC, KMS, S3, Logs disabled)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars

plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars

plan-advanced: init
	@echo "Planning with advanced-oidc fixture (creates OIDC provider/roles)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/advanced-oidc.tfvars

plan-oidc-existing: init
	@echo "Planning with oidc-existing fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc-existing.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture (No resources created)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve

apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

apply-advanced: init
	@echo "Applying with advanced-oidc fixture (creates OIDC provider/roles)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/advanced-oidc.tfvars -auto-approve

apply-oidc-existing: init
	@echo "Applying with oidc-existing fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc-existing.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture (No resources)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve

destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

destroy-advanced: init
	@echo "Destroying resources with advanced-oidc fixture (destroys OIDC provider/roles)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/advanced-oidc.tfvars -auto-approve

destroy-oidc-existing: init
	@echo "Destroying resources with oidc-existing fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc-existing.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture (No resources created)"

cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

cycle-advanced: plan-advanced apply-advanced destroy-advanced
	@echo "Completed full cycle with advanced-oidc fixture (creates/destroys OIDC provider/roles)"

cycle-oidc-existing: plan-oidc-existing apply-oidc-existing destroy-oidc-existing
	@echo "Completed full cycle with oidc-existing fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
