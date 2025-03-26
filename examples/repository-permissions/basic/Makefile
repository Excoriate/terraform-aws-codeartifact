# Makefile for Repository Permissions - Basic Example
# This file provides quick commands for testing the module with different fixtures

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-read-only plan-read-describe plan-cross-account-read plan-baseline-plus-custom plan-custom-only \
        apply-default apply-disabled apply-read-only apply-read-describe apply-cross-account-read apply-baseline-plus-custom apply-custom-only \
        destroy-default destroy-disabled destroy-read-only destroy-read-describe destroy-cross-account-read destroy-baseline-plus-custom destroy-custom-only \
        cycle-default cycle-disabled cycle-read-only cycle-read-describe cycle-cross-account-read cycle-baseline-plus-custom cycle-custom-only \
        clean

# Default target when just running 'make'
help:
	@echo "Repository Permissions - Basic Example"
	@echo ""
	@echo "Usage: make <target> [AWS_REGION=your-region]"
	@echo "Ensure 'domain_name' and 'repository_name' are set to EXISTING resources in the relevant fixtures/*.tfvars file before running apply/destroy/cycle targets."
	@echo ""
	@echo "Available commands:"
	@echo "  make init                         - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default                 - Plan with default baseline permissions (if any)"
	@echo "  make plan-disabled                - Plan with module entirely disabled (is_enabled=false)"
	@echo "  make plan-read-only               - Plan with only baseline read principals"
	@echo "  make plan-read-describe           - Plan with baseline read and describe principals"
	@echo "  make plan-cross-account-read      - Plan with a custom cross-account read statement"
	@echo "  make plan-baseline-plus-custom    - Plan with baseline principals and custom statements"
	@echo "  make plan-custom-only             - Plan with only custom statements"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default                - Apply default baseline permissions"
	@echo "  make apply-disabled               - Apply with module disabled"
	@echo "  make apply-read-only              - Apply baseline read principals"
	@echo "  make apply-read-describe          - Apply baseline read/describe principals"
	@echo "  make apply-cross-account-read     - Apply custom cross-account read statement"
	@echo "  make apply-baseline-plus-custom   - Apply baseline principals and custom statements"
	@echo "  make apply-custom-only            - Apply only custom statements"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default              - Destroy policy (resets to default AWS behavior)"
	@echo "  make destroy-disabled             - Destroy (no-op) with module disabled"
	@echo "  make destroy-read-only            - Destroy policy"
	@echo "  make destroy-read-describe        - Destroy policy"
	@echo "  make destroy-cross-account-read   - Destroy policy"
	@echo "  make destroy-baseline-plus-custom - Destroy policy"
	@echo "  make destroy-custom-only          - Destroy policy"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default                - Run full cycle with default settings"
	@echo "  make cycle-disabled               - Run full cycle with module disabled"
	@echo "  make cycle-read-only              - Run full cycle for read-only baseline"
	@echo "  make cycle-read-describe          - Run full cycle for read/describe baseline"
	@echo "  make cycle-cross-account-read     - Run full cycle for cross-account read"
	@echo "  make cycle-baseline-plus-custom   - Run full cycle for baseline + custom"
	@echo "  make cycle-custom-only            - Run full cycle for custom only"
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
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars
plan-disabled: init
	@echo "Planning with disabled fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars
plan-read-only: init
	@echo "Planning with read_only fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars
plan-read-describe: init
	@echo "Planning with read_describe fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/read_describe.tfvars
plan-cross-account-read: init
	@echo "Planning with cross_account_read fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/cross_account_read.tfvars
plan-baseline-plus-custom: init
	@echo "Planning with baseline_plus_custom fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/baseline_plus_custom.tfvars
plan-custom-only: init
	@echo "Planning with custom_only fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
apply-disabled: init
	@echo "Applying with disabled fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
apply-read-only: init
	@echo "Applying with read_only fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars -auto-approve
apply-read-describe: init
	@echo "Applying with read_describe fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/read_describe.tfvars -auto-approve
apply-cross-account-read: init
	@echo "Applying with cross_account_read fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/cross_account_read.tfvars -auto-approve
apply-baseline-plus-custom: init
	@echo "Applying with baseline_plus_custom fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/baseline_plus_custom.tfvars -auto-approve
apply-custom-only: init
	@echo "Applying with custom_only fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
destroy-disabled: init
	@echo "Destroying resources with disabled fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
destroy-read-only: init
	@echo "Destroying resources with read_only fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars -auto-approve
destroy-read-describe: init
	@echo "Destroying resources with read_describe fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/read_describe.tfvars -auto-approve
destroy-cross-account-read: init
	@echo "Destroying resources with cross_account_read fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/cross_account_read.tfvars -auto-approve
destroy-baseline-plus-custom: init
	@echo "Destroying resources with baseline_plus_custom fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/baseline_plus_custom.tfvars -auto-approve
destroy-custom-only: init
	@echo "Destroying resources with custom_only fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture"
cycle-read-only: plan-read-only apply-read-only destroy-read-only
	@echo "Completed full cycle with read_only fixture"
cycle-read-describe: plan-read-describe apply-read-describe destroy-read-describe
	@echo "Completed full cycle with read_describe fixture"
cycle-cross-account-read: plan-cross-account-read apply-cross-account-read destroy-cross-account-read
	@echo "Completed full cycle with cross_account_read fixture"
cycle-baseline-plus-custom: plan-baseline-plus-custom apply-baseline-plus-custom destroy-baseline-plus-custom
	@echo "Completed full cycle with baseline_plus_custom fixture"
cycle-custom-only: plan-custom-only apply-custom-only destroy-custom-only
	@echo "Completed full cycle with custom_only fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files in $(CURDIR)..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
