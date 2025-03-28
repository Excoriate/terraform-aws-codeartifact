# Makefile for Domain Permissions - Dynamic Policy Construction Example
# This file provides quick commands for testing the module with different dynamic policy fixtures

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-read_only plan-list_only plan-auth_token_only plan-custom_only plan-combined_baseline plan-combined_all \
        apply-default apply-disabled apply-read_only apply-list_only apply-auth_token_only apply-custom_only apply-combined_baseline apply-combined_all \
        destroy-default destroy-disabled destroy-read_only destroy-list_only destroy-auth_token_only destroy-custom_only destroy-combined_baseline destroy-combined_all \
        cycle-default cycle-disabled cycle-read_only cycle-list_only cycle-auth_token_only cycle-custom_only cycle-combined_baseline cycle-combined_all \
        clean

# Default target when just running 'make'
help:
	@echo "Domain Permissions - Dynamic Policy Construction Example"
	@echo ""
	@echo "Usage: make <target> [AWS_REGION=your-region]"
	@echo "This example creates its own temporary CodeArtifact domain."
	@echo "Each fixture demonstrates different dynamic domain permission configurations."
	@echo ""
	@echo "Available commands:"
	@echo "  make init                         - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default                 - Plan with no dynamic inputs (module creates no policy resource)"
	@echo "  make plan-disabled                - Plan with module entirely disabled (is_enabled=false)"
	@echo "  make plan-read_only               - Plan with only read_principals"
	@echo "  make plan-list_only               - Plan with only list_repo_principals"
	@echo "  make plan-auth_token_only         - Plan with only authorization_token_principals"
	@echo "  make plan-custom_only             - Plan with only custom_policy_statements"
	@echo "  make plan-combined_baseline       - Plan combining read/list principals"
	@echo "  make plan-combined_all            - Plan combining baseline principals and custom statements"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default                - Apply with no dynamic inputs"
	@echo "  make apply-disabled               - Apply with module disabled"
	@echo "  make apply-read_only              - Apply with only read_principals"
	@echo "  make apply-list_only              - Apply with only list_repo_principals"
	@echo "  make apply-auth_token_only        - Apply with only authorization_token_principals"
	@echo "  make apply-custom_only            - Apply with only custom_policy_statements"
	@echo "  make apply-combined_baseline      - Apply combining read/list principals"
	@echo "  make apply-combined_all           - Apply combining baseline principals and custom statements"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default              - Destroy resources with default configuration"
	@echo "  make destroy-disabled             - Destroy resources with module disabled"
	@echo "  make destroy-read_only            - Destroy resources with read_only fixture"
	@echo "  make destroy-list_only            - Destroy resources with list_only fixture"
	@echo "  make destroy-auth_token_only      - Destroy resources with auth_token_only fixture"
	@echo "  make destroy-custom_only          - Destroy resources with custom_only fixture"
	@echo "  make destroy-combined_baseline    - Destroy resources with combined_baseline fixture"
	@echo "  make destroy-combined_all         - Destroy resources with combined_all fixture"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default                - Run full cycle with default settings"
	@echo "  make cycle-disabled               - Run full cycle with module disabled"
	@echo "  make cycle-read_only              - Run full cycle for read_only"
	@echo "  make cycle-list_only              - Run full cycle for list_only"
	@echo "  make cycle-auth_token_only        - Run full cycle for auth_token_only"
	@echo "  make cycle-custom_only            - Run full cycle for custom_only"
	@echo "  make cycle-combined_baseline      - Run full cycle for combined_baseline"
	@echo "  make cycle-combined_all           - Run full cycle for combined_all"
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

# --- Plan commands ---
plan-default: init
	@echo "Planning with default fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars
plan-disabled: init
	@echo "Planning with disabled fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars
plan-read_only: init
	@echo "Planning with read_only fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars
plan-list_only: init
	@echo "Planning with list_only fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/list_only.tfvars
plan-auth_token_only: init
	@echo "Planning with auth_token_only fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/auth_token_only.tfvars
plan-custom_only: init
	@echo "Planning with custom_only fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars
plan-combined_baseline: init
	@echo "Planning with combined_baseline fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_baseline.tfvars
plan-combined_all: init
	@echo "Planning with combined_all fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_all.tfvars

# --- Apply commands ---
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
apply-disabled: init
	@echo "Applying with disabled fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
apply-read_only: init
	@echo "Applying with read_only fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars -auto-approve
apply-list_only: init
	@echo "Applying with list_only fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/list_only.tfvars -auto-approve
apply-auth_token_only: init
	@echo "Applying with auth_token_only fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/auth_token_only.tfvars -auto-approve
apply-custom_only: init
	@echo "Applying with custom_only fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars -auto-approve
apply-combined_baseline: init
	@echo "Applying with combined_baseline fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_baseline.tfvars -auto-approve
apply-combined_all: init
	@echo "Applying with combined_all fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_all.tfvars -auto-approve

# --- Destroy commands ---
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
destroy-disabled: init
	@echo "Destroying resources with disabled fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
destroy-read_only: init
	@echo "Destroying resources with read_only fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/read_only.tfvars -auto-approve
destroy-list_only: init
	@echo "Destroying resources with list_only fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/list_only.tfvars -auto-approve
destroy-auth_token_only: init
	@echo "Destroying resources with auth_token_only fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/auth_token_only.tfvars -auto-approve
destroy-custom_only: init
	@echo "Destroying resources with custom_only fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/custom_only.tfvars -auto-approve
destroy-combined_baseline: init
	@echo "Destroying resources with combined_baseline fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_baseline.tfvars -auto-approve
destroy-combined_all: init
	@echo "Destroying resources with combined_all fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/combined_all.tfvars -auto-approve

# --- Run full cycle commands ---
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture"
cycle-read_only: plan-read_only apply-read_only destroy-read_only
	@echo "Completed full cycle with read_only fixture"
cycle-list_only: plan-list_only apply-list_only destroy-list_only
	@echo "Completed full cycle with list_only fixture"
cycle-auth_token_only: plan-auth_token_only apply-auth_token_only destroy-auth_token_only
	@echo "Completed full cycle with auth_token_only fixture"
cycle-custom_only: plan-custom_only apply-custom_only destroy-custom_only
	@echo "Completed full cycle with custom_only fixture"
cycle-combined_baseline: plan-combined_baseline apply-combined_baseline destroy-combined_baseline
	@echo "Completed full cycle with combined_baseline fixture"
cycle-combined_all: plan-combined_all apply-combined_all destroy-combined_all
	@echo "Completed full cycle with combined_all fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files in $(CURDIR)..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
