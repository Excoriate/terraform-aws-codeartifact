# Makefile for CodeArtifact Domain Permissions Module - Basic Example
# This file provides quick commands for testing the module

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-read-only-policy plan-admin-policy plan-custom-principal plan-no-policy plan-custom-domain-owner \
        apply-default apply-disabled apply-read-only-policy apply-admin-policy apply-custom-principal apply-no-policy apply-custom-domain-owner \
        destroy-default destroy-disabled destroy-read-only-policy destroy-admin-policy destroy-custom-principal destroy-no-policy destroy-custom-domain-owner \
        cycle-default cycle-disabled cycle-read-only-policy cycle-admin-policy cycle-custom-principal cycle-no-policy cycle-custom-domain-owner \
        clean

# Default target when just running 'make'
help:
	@echo "CodeArtifact Domain Permissions Module - Basic Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                               - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default                       - Plan with default configuration"
	@echo "  make plan-disabled                      - Plan with module entirely disabled"
	@echo "  make plan-read-only-policy              - Plan with read-only policy type"
	@echo "  make plan-admin-policy                  - Plan with admin policy type"
	@echo "  make plan-custom-principal              - Plan with custom principal ARN"
	@echo "  make plan-no-policy                     - Plan with no policy applied"
	@echo "  make plan-custom-domain-owner           - Plan with custom domain owner"
	@echo ""
	@echo "  Apply commands (terraform apply):"
	@echo "  make apply-default                      - Apply with default configuration"
	@echo "  make apply-disabled                     - Apply with module entirely disabled"
	@echo "  make apply-read-only-policy             - Apply with read-only policy type"
	@echo "  make apply-admin-policy                 - Apply with admin policy type"
	@echo "  make apply-custom-principal             - Apply with custom principal ARN"
	@echo "  make apply-no-policy                    - Apply with no policy applied"
	@echo "  make apply-custom-domain-owner          - Apply with custom domain owner"
	@echo ""
	@echo "  Destroy commands (terraform destroy):"
	@echo "  make destroy-default                    - Destroy resources with default configuration"
	@echo "  make destroy-disabled                   - Destroy resources with module entirely disabled"
	@echo "  make destroy-read-only-policy           - Destroy resources with read-only policy type"
	@echo "  make destroy-admin-policy               - Destroy resources with admin policy type"
	@echo "  make destroy-custom-principal           - Destroy resources with custom principal ARN"
	@echo "  make destroy-no-policy                  - Destroy resources with no policy applied"
	@echo "  make destroy-custom-domain-owner        - Destroy resources with custom domain owner"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default                      - Run full cycle with default configuration"
	@echo "  make cycle-disabled                     - Run full cycle with module entirely disabled"
	@echo "  make cycle-read-only-policy             - Run full cycle with read-only policy type"
	@echo "  make cycle-admin-policy                 - Run full cycle with admin policy type"
	@echo "  make cycle-custom-principal             - Run full cycle with custom principal ARN"
	@echo "  make cycle-no-policy                    - Run full cycle with no policy applied"
	@echo "  make cycle-custom-domain-owner          - Run full cycle with custom domain owner"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                              - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  AWS_REGION                              - AWS region to deploy resources (default: us-west-2)"

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

plan-read-only-policy: init
	@echo "Planning with read-only policy type..."
	terraform plan -var-file=fixtures/read-only-policy.tfvars

plan-admin-policy: init
	@echo "Planning with admin policy type..."
	terraform plan -var-file=fixtures/admin-policy.tfvars

plan-custom-principal: init
	@echo "Planning with custom principal ARN..."
	terraform plan -var-file=fixtures/custom-principal.tfvars

plan-no-policy: init
	@echo "Planning with no policy applied..."
	terraform plan -var-file=fixtures/no-policy.tfvars

plan-custom-domain-owner: init
	@echo "Planning with custom domain owner..."
	terraform plan -var-file=fixtures/custom-domain-owner.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture..."
	terraform apply -var-file=fixtures/default.tfvars -auto-approve

apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var-file=fixtures/disabled.tfvars -auto-approve

apply-read-only-policy: init
	@echo "Applying with read-only policy type..."
	terraform apply -var-file=fixtures/read-only-policy.tfvars -auto-approve

apply-admin-policy: init
	@echo "Applying with admin policy type..."
	terraform apply -var-file=fixtures/admin-policy.tfvars -auto-approve

apply-custom-principal: init
	@echo "Applying with custom principal ARN..."
	terraform apply -var-file=fixtures/custom-principal.tfvars -auto-approve

apply-no-policy: init
	@echo "Applying with no policy applied..."
	terraform apply -var-file=fixtures/no-policy.tfvars -auto-approve

apply-custom-domain-owner: init
	@echo "Applying with custom domain owner..."
	terraform apply -var-file=fixtures/custom-domain-owner.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var-file=fixtures/default.tfvars -auto-approve

destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var-file=fixtures/disabled.tfvars -auto-approve

destroy-read-only-policy: init
	@echo "Destroying resources with read-only policy type..."
	terraform destroy -var-file=fixtures/read-only-policy.tfvars -auto-approve

destroy-admin-policy: init
	@echo "Destroying resources with admin policy type..."
	terraform destroy -var-file=fixtures/admin-policy.tfvars -auto-approve

destroy-custom-principal: init
	@echo "Destroying resources with custom principal ARN..."
	terraform destroy -var-file=fixtures/custom-principal.tfvars -auto-approve

destroy-no-policy: init
	@echo "Destroying resources with no policy applied..."
	terraform destroy -var-file=fixtures/no-policy.tfvars -auto-approve

destroy-custom-domain-owner: init
	@echo "Destroying resources with custom domain owner..."
	terraform destroy -var-file=fixtures/custom-domain-owner.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"

cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

cycle-read-only-policy: plan-read-only-policy apply-read-only-policy destroy-read-only-policy
	@echo "Completed full cycle with read-only policy type"

cycle-admin-policy: plan-admin-policy apply-admin-policy destroy-admin-policy
	@echo "Completed full cycle with admin policy type"

cycle-custom-principal: plan-custom-principal apply-custom-principal destroy-custom-principal
	@echo "Completed full cycle with custom principal ARN"

cycle-no-policy: plan-no-policy apply-no-policy destroy-no-policy
	@echo "Completed full cycle with no policy applied"

cycle-custom-domain-owner: plan-custom-domain-owner apply-custom-domain-owner destroy-custom-domain-owner
	@echo "Completed full cycle with custom domain owner"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
