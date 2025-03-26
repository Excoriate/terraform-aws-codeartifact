# Makefile for AWS CodeArtifact Foundation Basic Example
# This file provides quick commands for testing the foundation module

# Default AWS region if not specified
AWS_REGION ?= us-west-2

.PHONY: help init \
        plan-default plan-disabled plan-kms-disabled plan-s3-disabled plan-logs-disabled plan-oidc-gitlab plan-oidc-github \
        apply-default apply-disabled apply-kms-disabled apply-s3-disabled apply-logs-disabled apply-oidc-gitlab apply-oidc-github \
        destroy-default destroy-disabled destroy-kms-disabled destroy-s3-disabled destroy-logs-disabled destroy-oidc-gitlab destroy-oidc-github \
        cycle-default cycle-disabled cycle-kms-disabled cycle-s3-disabled cycle-logs-disabled cycle-oidc-gitlab cycle-oidc-github \
        clean

# Default target when just running 'make'
help:
	@echo "AWS CodeArtifact Foundation Module - Basic Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                 - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default         - Plan with all components enabled"
	@echo "  make plan-disabled        - Plan with module entirely disabled"
	@echo "  make plan-kms-disabled    - Plan with KMS key component disabled"
	@echo "  make plan-s3-disabled     - Plan with S3 bucket component disabled"
	@echo "  make plan-logs-disabled   - Plan with CloudWatch logs component disabled"
	@echo "  make plan-oidc-gitlab     - Plan with GitLab OIDC provider enabled"
	@echo "  make plan-oidc-github     - Plan with GitHub OIDC provider enabled"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default        - Apply with all components enabled"
	@echo "  make apply-disabled       - Apply with module entirely disabled"
	@echo "  make apply-kms-disabled   - Apply with KMS key component disabled"
	@echo "  make apply-s3-disabled    - Apply with S3 bucket component disabled"
	@echo "  make apply-logs-disabled  - Apply with CloudWatch logs component disabled"
	@echo "  make apply-oidc-gitlab    - Apply with GitLab OIDC provider enabled"
	@echo "  make apply-oidc-github    - Apply with GitHub OIDC provider enabled"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default      - Destroy resources with all components enabled"
	@echo "  make destroy-disabled     - Destroy resources with module entirely disabled"
	@echo "  make destroy-kms-disabled - Destroy resources with KMS key component disabled"
	@echo "  make destroy-s3-disabled  - Destroy resources with S3 bucket component disabled"
	@echo "  make destroy-logs-disabled- Destroy resources with CloudWatch logs component disabled"
	@echo "  make destroy-oidc-gitlab  - Destroy resources with GitLab OIDC provider enabled"
	@echo "  make destroy-oidc-github  - Destroy resources with GitHub OIDC provider enabled"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default        - Run full cycle with all components enabled"
	@echo "  make cycle-disabled       - Run full cycle with module entirely disabled"
	@echo "  make cycle-kms-disabled   - Run full cycle with KMS key component disabled"
	@echo "  make cycle-s3-disabled    - Run full cycle with S3 bucket component disabled"
	@echo "  make cycle-logs-disabled  - Run full cycle with CloudWatch logs component disabled"
	@echo "  make cycle-oidc-gitlab    - Run full cycle with GitLab OIDC provider enabled"
	@echo "  make cycle-oidc-github    - Run full cycle with GitHub OIDC provider enabled"
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
	@echo "Planning with default fixture (all components enabled)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars

plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars

plan-kms-disabled: init
	@echo "Planning with KMS component disabled..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/kms-disabled.tfvars

plan-s3-disabled: init
	@echo "Planning with S3 bucket component disabled..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/s3-disabled.tfvars

plan-logs-disabled: init
	@echo "Planning with CloudWatch logs component disabled..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/logs-disabled.tfvars

plan-oidc-gitlab: init
	@echo "Planning with oidc_gitlab fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_gitlab.tfvars

plan-oidc-github: init
	@echo "Planning with oidc_github fixture..."
	terraform plan -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_github.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture (all components enabled)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve

apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

apply-kms-disabled: init
	@echo "Applying with KMS component disabled..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/kms-disabled.tfvars -auto-approve

apply-s3-disabled: init
	@echo "Applying with S3 bucket component disabled..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/s3-disabled.tfvars -auto-approve

apply-logs-disabled: init
	@echo "Applying with CloudWatch logs component disabled..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/logs-disabled.tfvars -auto-approve

apply-oidc-gitlab: init
	@echo "Applying with oidc_gitlab fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_gitlab.tfvars -auto-approve

apply-oidc-github: init
	@echo "Applying with oidc_github fixture..."
	terraform apply -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_github.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture (all components enabled)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/default.tfvars -auto-approve

destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

destroy-kms-disabled: init
	@echo "Destroying resources with KMS component disabled..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/kms-disabled.tfvars -auto-approve

destroy-s3-disabled: init
	@echo "Destroying resources with S3 bucket component disabled..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/s3-disabled.tfvars -auto-approve

destroy-logs-disabled: init
	@echo "Destroying resources with CloudWatch logs component disabled..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/logs-disabled.tfvars -auto-approve

destroy-oidc-gitlab: init
	@echo "Destroying resources with oidc_gitlab fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_gitlab.tfvars -auto-approve

destroy-oidc-github: init
	@echo "Destroying resources with oidc_github fixture..."
	terraform destroy -var="aws_region=${AWS_REGION}" -var-file=fixtures/oidc_github.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture (all components enabled)"

cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

cycle-kms-disabled: plan-kms-disabled apply-kms-disabled destroy-kms-disabled
	@echo "Completed full cycle with KMS component disabled"

cycle-s3-disabled: plan-s3-disabled apply-s3-disabled destroy-s3-disabled
	@echo "Completed full cycle with S3 bucket component disabled"

cycle-logs-disabled: plan-logs-disabled apply-logs-disabled destroy-logs-disabled
	@echo "Completed full cycle with CloudWatch logs component disabled"

cycle-oidc-gitlab: plan-oidc-gitlab apply-oidc-gitlab destroy-oidc-gitlab
	@echo "Completed full cycle with oidc_gitlab fixture"

cycle-oidc-github: plan-oidc-github apply-oidc-github destroy-oidc-github
	@echo "Completed full cycle with oidc_github fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
