# Makefile for Repository - Basic Example
# This file provides quick commands for testing the module with different fixtures

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-hosted plan-internal-proxy plan-public-proxy plan-combined-proxy plan-with-policy \
        apply-default apply-disabled apply-hosted apply-internal-proxy apply-public-proxy apply-combined-proxy apply-with-policy \
        destroy-default destroy-disabled destroy-hosted destroy-internal-proxy destroy-public-proxy destroy-combined-proxy destroy-with-policy \
        cycle-default cycle-disabled cycle-hosted cycle-internal-proxy cycle-public-proxy cycle-combined-proxy cycle-with-policy \
        clean

# Default target when just running 'make'
help:
	@echo "Repository - Basic Example"
	@echo ""
	@echo "Usage: make <target> [AWS_REGION=your-region]"
	@echo "Ensure 'domain_name' is set in the relevant fixtures/*.tfvars file before running apply/destroy/cycle targets."
	@echo ""
	@echo "Available commands:"
	@echo "  make init                     - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default             - Plan with default module settings"
	@echo "  make plan-disabled            - Plan with module entirely disabled (is_enabled=false)"
	@echo "  make plan-hosted              - Plan for a basic hosted repository"
	@echo "  make plan-internal-proxy      - Plan for a repository proxying internal upstreams"
	@echo "  make plan-public-proxy        - Plan for a repository proxying public external connections"
	@echo "  make plan-combined-proxy      - Plan for a repository with both internal and external proxies"
	@echo "  make plan-with-policy         - Plan for a repository with a custom policy document"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default            - Apply default module settings"
	@echo "  make apply-disabled           - Apply with module disabled"
	@echo "  make apply-hosted             - Apply a basic hosted repository"
	@echo "  make apply-internal-proxy     - Apply an internal proxy repository"
	@echo "  make apply-public-proxy       - Apply a public proxy repository"
	@echo "  make apply-combined-proxy     - Apply a combined proxy repository"
	@echo "  make apply-with-policy        - Apply a repository with a custom policy"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default          - Destroy default resources"
	@echo "  make destroy-disabled         - Destroy (no-op) with module disabled"
	@echo "  make destroy-hosted           - Destroy the hosted repository"
	@echo "  make destroy-internal-proxy   - Destroy the internal proxy repository"
	@echo "  make destroy-public-proxy     - Destroy the public proxy repository"
	@echo "  make destroy-combined-proxy   - Destroy the combined proxy repository"
	@echo "  make destroy-with-policy      - Destroy the repository with a policy"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default            - Run full cycle with default settings"
	@echo "  make cycle-disabled           - Run full cycle with module disabled"
	@echo "  make cycle-hosted             - Run full cycle for a hosted repository"
	@echo "  make cycle-internal-proxy     - Run full cycle for an internal proxy repository"
	@echo "  make cycle-public-proxy       - Run full cycle for a public proxy repository"
	@echo "  make cycle-combined-proxy     - Run full cycle for a combined proxy repository"
	@echo "  make cycle-with-policy        - Run full cycle for a repository with a policy"
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
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars
plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars
plan-hosted: init
	@echo "Planning with hosted fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/hosted.tfvars
plan-internal-proxy: init
	@echo "Planning with internal_proxy fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/internal_proxy.tfvars
plan-public-proxy: init
	@echo "Planning with public_proxy fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/public_proxy.tfvars
plan-combined-proxy: init
	@echo "Planning with combined_proxy fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/combined_proxy.tfvars
plan-with-policy: init
	@echo "Planning with with_policy fixture..."
	terraform plan -var="region=${AWS_REGION}" -var-file=fixtures/with_policy.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
apply-hosted: init
	@echo "Applying with hosted fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/hosted.tfvars -auto-approve
apply-internal-proxy: init
	@echo "Applying with internal_proxy fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/internal_proxy.tfvars -auto-approve
apply-public-proxy: init
	@echo "Applying with public_proxy fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/public_proxy.tfvars -auto-approve
apply-combined-proxy: init
	@echo "Applying with combined_proxy fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/combined_proxy.tfvars -auto-approve
apply-with-policy: init
	@echo "Applying with with_policy fixture..."
	terraform apply -var="region=${AWS_REGION}" -var-file=fixtures/with_policy.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve
destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve
destroy-hosted: init
	@echo "Destroying resources with hosted fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/hosted.tfvars -auto-approve
destroy-internal-proxy: init
	@echo "Destroying resources with internal_proxy fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/internal_proxy.tfvars -auto-approve
destroy-public-proxy: init
	@echo "Destroying resources with public_proxy fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/public_proxy.tfvars -auto-approve
destroy-combined-proxy: init
	@echo "Destroying resources with combined_proxy fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/combined_proxy.tfvars -auto-approve
destroy-with-policy: init
	@echo "Destroying resources with with_policy fixture..."
	terraform destroy -var="region=${AWS_REGION}" -var-file=fixtures/with_policy.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"
cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"
cycle-hosted: plan-hosted apply-hosted destroy-hosted
	@echo "Completed full cycle with hosted fixture"
cycle-internal-proxy: plan-internal-proxy apply-internal-proxy destroy-internal-proxy
	@echo "Completed full cycle with internal_proxy fixture"
cycle-public-proxy: plan-public-proxy apply-public-proxy destroy-public-proxy
	@echo "Completed full cycle with public_proxy fixture"
cycle-combined-proxy: plan-combined-proxy apply-combined-proxy destroy-combined-proxy
	@echo "Completed full cycle with combined_proxy fixture"
cycle-with-policy: plan-with-policy apply-with-policy destroy-with-policy
	@echo "Completed full cycle with with_policy fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files in $(CURDIR)..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
