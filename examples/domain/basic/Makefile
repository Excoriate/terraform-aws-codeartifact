# Makefile for CodeArtifact Domain Module - Basic Example
# This file provides quick commands for testing the module

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-with-domain-permissions plan-custom-domain-owner plan-no-encryption plan-combined-features \
        apply-default apply-disabled apply-with-domain-permissions apply-custom-domain-owner apply-no-encryption apply-combined-features \
        destroy-default destroy-disabled destroy-with-domain-permissions destroy-custom-domain-owner destroy-no-encryption destroy-combined-features \
        cycle-default cycle-disabled cycle-with-domain-permissions cycle-custom-domain-owner cycle-no-encryption cycle-combined-features \
        clean

# Default target when just running 'make'
help:
	@echo "CodeArtifact Domain Module - Basic Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                             - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default                     - Plan with default configuration"
	@echo "  make plan-disabled                    - Plan with module entirely disabled"
	@echo "  make plan-with-domain-permissions     - Plan with domain permissions policy enabled"
	@echo "  make plan-custom-domain-owner         - Plan with custom domain owner"
	@echo "  make plan-no-encryption               - Plan with default AWS encryption (no custom KMS key)"
	@echo "  make plan-combined-features           - Plan with multiple features enabled"
	@echo ""
	@echo "  Apply commands (terraform apply):"
	@echo "  make apply-default                    - Apply with default configuration"
	@echo "  make apply-disabled                   - Apply with module entirely disabled"
	@echo "  make apply-with-domain-permissions    - Apply with domain permissions policy enabled"
	@echo "  make apply-custom-domain-owner        - Apply with custom domain owner"
	@echo "  make apply-no-encryption              - Apply with default AWS encryption (no custom KMS key)"
	@echo "  make apply-combined-features          - Apply with multiple features enabled"
	@echo ""
	@echo "  Destroy commands (terraform destroy):"
	@echo "  make destroy-default                  - Destroy resources with default configuration"
	@echo "  make destroy-disabled                 - Destroy resources with module entirely disabled"
	@echo "  make destroy-with-domain-permissions  - Destroy resources with domain permissions policy enabled"
	@echo "  make destroy-custom-domain-owner      - Destroy resources with custom domain owner"
	@echo "  make destroy-no-encryption            - Destroy resources with default AWS encryption (no custom KMS key)"
	@echo "  make destroy-combined-features        - Destroy resources with multiple features enabled"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default                    - Run full cycle with default configuration"
	@echo "  make cycle-disabled                   - Run full cycle with module entirely disabled"
	@echo "  make cycle-with-domain-permissions    - Run full cycle with domain permissions policy enabled"
	@echo "  make cycle-custom-domain-owner        - Run full cycle with custom domain owner"
	@echo "  make cycle-no-encryption              - Run full cycle with default AWS encryption (no custom KMS key)"
	@echo "  make cycle-combined-features          - Run full cycle with multiple features enabled"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                            - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION                            - AWS region to deploy resources (default: us-west-2)"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan commands
plan-default: init
	@echo "Planning with default fixture..."
	terraform plan -var-file=fixtures/default.tfvars

plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var-file=fixtures/disabled.tfvars

plan-with-domain-permissions: init
	@echo "Planning with domain permissions policy enabled..."
	terraform plan -var-file=fixtures/with-domain-permissions.tfvars

plan-custom-domain-owner: init
	@echo "Planning with custom domain owner..."
	terraform plan -var-file=fixtures/custom-domain-owner.tfvars

plan-no-encryption: init
	@echo "Planning with default AWS encryption (no custom KMS key)..."
	terraform plan -var-file=fixtures/no-encryption.tfvars

plan-combined-features: init
	@echo "Planning with multiple features enabled..."
	terraform plan -var-file=fixtures/combined-features.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var-file=fixtures/default.tfvars -auto-approve

apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var-file=fixtures/disabled.tfvars -auto-approve

apply-with-domain-permissions: init
	@echo "Applying with domain permissions policy enabled..."
	terraform apply -var-file=fixtures/with-domain-permissions.tfvars -auto-approve

apply-custom-domain-owner: init
	@echo "Applying with custom domain owner..."
	terraform apply -var-file=fixtures/custom-domain-owner.tfvars -auto-approve

apply-no-encryption: init
	@echo "Applying with default AWS encryption (no custom KMS key)..."
	terraform apply -var-file=fixtures/no-encryption.tfvars -auto-approve

apply-combined-features: init
	@echo "Applying with multiple features enabled..."
	terraform apply -var-file=fixtures/combined-features.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var-file=fixtures/default.tfvars -auto-approve

destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var-file=fixtures/disabled.tfvars -auto-approve

destroy-with-domain-permissions: init
	@echo "Destroying resources with domain permissions policy enabled..."
	terraform destroy -var-file=fixtures/with-domain-permissions.tfvars -auto-approve

destroy-custom-domain-owner: init
	@echo "Destroying resources with custom domain owner..."
	terraform destroy -var-file=fixtures/custom-domain-owner.tfvars -auto-approve

destroy-no-encryption: init
	@echo "Destroying resources with default AWS encryption (no custom KMS key)..."
	terraform destroy -var-file=fixtures/no-encryption.tfvars -auto-approve

destroy-combined-features: init
	@echo "Destroying resources with multiple features enabled..."
	terraform destroy -var-file=fixtures/combined-features.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"

cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

cycle-with-domain-permissions: plan-with-domain-permissions apply-with-domain-permissions destroy-with-domain-permissions
	@echo "Completed full cycle with domain permissions policy enabled"

cycle-custom-domain-owner: plan-custom-domain-owner apply-custom-domain-owner destroy-custom-domain-owner
	@echo "Completed full cycle with custom domain owner"

cycle-no-encryption: plan-no-encryption apply-no-encryption destroy-no-encryption
	@echo "Completed full cycle with default AWS encryption (no custom KMS key)"

cycle-combined-features: plan-combined-features apply-combined-features destroy-combined-features
	@echo "Completed full cycle with multiple features enabled"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
