# Makefile for Domain Permissions - Basic Example
# This file provides quick commands for testing the module with different fixtures

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-cross-account plan-custom-domain-owner plan-no-policy \
        apply-default apply-disabled apply-cross-account apply-custom-domain-owner apply-no-policy \
        destroy-default destroy-disabled destroy-cross-account destroy-custom-domain-owner destroy-no-policy \
        cycle-default cycle-disabled cycle-cross-account cycle-custom-domain-owner cycle-no-policy \
        clean

# Default target when just running 'make'
help:
	@echo "Domain Permissions - Basic Example"
	@echo ""
	@echo "Usage: make <target> [AWS_REGION=your-region]"
	@echo "This example is fully self-contained and creates its own CodeArtifact domain."
	@echo "Each fixture demonstrates different domain permission configurations."
	@echo ""
	@echo "Available commands:"
	@echo "  make init                         - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default                 - Plan with default baseline permissions"
	@echo "  make plan-disabled                - Plan with module entirely disabled (is_enabled=false)"
	@echo "  make plan-cross-account           - Plan with a custom cross-account statement"
	@echo "  make plan-custom-domain-owner     - Plan with a custom domain owner"
	@echo "  make plan-no-policy               - Plan with no policy inputs (should create minimal default)"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default                - Apply default baseline permissions"
	@echo "  make apply-disabled               - Apply with module disabled"
	@echo "  make apply-cross-account          - Apply custom cross-account statement"
	@echo "  make apply-custom-domain-owner    - Apply with a custom domain owner"
	@echo "  make apply-no-policy              - Apply with no policy inputs"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default              - Destroy resources with default configuration"
	@echo "  make destroy-disabled             - Destroy resources with module disabled"
	@echo "  make destroy-cross-account        - Destroy resources with cross-account permissions"
	@echo "  make destroy-custom-domain-owner  - Destroy resources with custom domain owner"
	@echo "  make destroy-no-policy            - Destroy resources with no policy inputs"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default                - Run full cycle with default settings"
	@echo "  make cycle-disabled               - Run full cycle with module disabled"
	@echo "  make cycle-cross-account          - Run full cycle for cross-account"
	@echo "  make cycle-custom-domain-owner    - Run full cycle for custom domain owner"
	@echo "  make cycle-no-policy              - Run full cycle for no policy inputs"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                        - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION                        - AWS region to deploy resources (default: us-west-2)"

# Initialize Terraform
init:
	@echo "Initializing Terraform in $(CURDIR)..."
	terraform init

# Plan commands
plan-default: init
	@echo "Planning with default fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars
plan-disabled: init
	@echo "Planning with disabled fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars
plan-cross-account: init
	@echo "Planning with cross_account fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/cross_account.tfvars
plan-custom-domain-owner: init
	@echo "Planning with custom-domain-owner fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom-domain-owner.tfvars
plan-no-policy: init
	@echo "Planning with no-policy fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/no-policy.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
apply-disabled: init
	@echo "Applying with disabled fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
apply-cross-account: init
	@echo "Applying with cross_account fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/cross_account.tfvars -auto-approve
apply-custom-domain-owner: init
	@echo "Applying with custom-domain-owner fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom-domain-owner.tfvars -auto-approve
apply-no-policy: init
	@echo "Applying with no-policy fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/no-policy.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
destroy-disabled: init
	@echo "Destroying resources with disabled fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
destroy-cross-account: init
	@echo "Destroying resources with cross_account fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/cross_account.tfvars -auto-approve
destroy-custom-domain-owner: init
	@echo "Destroying resources with custom-domain-owner fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom-domain-owner.tfvars -auto-approve
destroy-no-policy: init
	@echo "Destroying resources with no-policy fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/no-policy.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture"
cycle-cross-account: plan-cross-account apply-cross-account destroy-cross-account
	@echo "Completed full cycle with cross_account fixture"
cycle-custom-domain-owner: plan-custom-domain-owner apply-custom-domain-owner destroy-custom-domain-owner
	@echo "Completed full cycle with custom-domain-owner fixture"
cycle-no-policy: plan-no-policy apply-no-policy destroy-no-policy
	@echo "Completed full cycle with no-policy fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files in $(CURDIR)..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
