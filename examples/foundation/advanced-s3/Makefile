# Makefile for AWS CodeArtifact Foundation - Advanced S3 Example
# This file provides quick commands for testing the foundation module with S3 replication

# Default AWS region if not specified - Ensure these match your intended regions
SOURCE_REGION ?= us-east-1
REPLICA_REGION ?= eu-west-1

.PHONY: help init \
        plan-default plan-disabled plan-replication-enabled \
        apply-default apply-disabled apply-replication-enabled \
        destroy-default destroy-disabled destroy-replication-enabled \
        cycle-default cycle-disabled cycle-replication-enabled \
        clean

# Default target when just running 'make'
help:
	@echo "AWS CodeArtifact Foundation Module - Advanced S3 Example"
	@echo ""
	@echo "Available commands:"
	@echo "  make init                      - Initialize Terraform"
	@echo ""
	@echo "  Plan commands (terraform plan):"
	@echo "  make plan-default              - Plan with default fixture (replication disabled)"
	@echo "  make plan-disabled             - Plan with module entirely disabled"
	@echo "  make plan-replication-enabled  - Plan enabling S3 replication"
	@echo ""
	@echo "  Apply commands (terraform apply -auto-approve):"
	@echo "  make apply-default             - Apply with default fixture (replication disabled)"
	@echo "  make apply-disabled            - Apply with module entirely disabled"
	@echo "  make apply-replication-enabled - Apply enabling S3 replication"
	@echo ""
	@echo "  Destroy commands (terraform destroy -auto-approve):"
	@echo "  make destroy-default           - Destroy resources with default fixture"
	@echo "  make destroy-disabled          - Destroy resources with module entirely disabled"
	@echo "  make destroy-replication-enabled - Destroy resources with S3 replication enabled"
	@echo ""
	@echo "  Complete cycle commands (plan, apply, and destroy):"
	@echo "  make cycle-default             - Run full cycle with default fixture"
	@echo "  make cycle-disabled            - Run full cycle with module entirely disabled"
	@echo "  make cycle-replication-enabled - Run full cycle enabling S3 replication"
	@echo ""
	@echo "  Utility commands:"
	@echo "  make clean                     - Remove .terraform directory and other Terraform files"
	@echo ""
	@echo "Environment variables:"
	@echo "  SOURCE_REGION                  - AWS region for source resources (default: us-east-1)"
	@echo "  REPLICA_REGION                 - AWS region for replica resources (default: eu-west-1)"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan commands
plan-default: init
	@echo "Planning with default fixture (replication disabled)..."
	terraform plan -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/default.tfvars

plan-disabled: init
	@echo "Planning with disabled fixture (module entirely disabled)..."
	terraform plan -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/disabled.tfvars

plan-replication-enabled: init
	@echo "Planning with replication-enabled fixture..."
	terraform plan -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/replication-enabled.tfvars

# Apply commands
apply-default: init
	@echo "Applying with default fixture (replication disabled)..."
	terraform apply -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/default.tfvars -auto-approve

apply-disabled: init
	@echo "Applying with disabled fixture (module entirely disabled)..."
	terraform apply -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

apply-replication-enabled: init
	@echo "Applying with replication-enabled fixture..."
	terraform apply -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/replication-enabled.tfvars -auto-approve

# Destroy commands
destroy-default: init
	@echo "Destroying resources with default fixture..."
	terraform destroy -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/default.tfvars -auto-approve

destroy-disabled: init
	@echo "Destroying resources with disabled fixture (module entirely disabled)..."
	terraform destroy -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/disabled.tfvars -auto-approve

destroy-replication-enabled: init
	@echo "Destroying resources with replication-enabled fixture..."
	terraform destroy -var="source_region=${SOURCE_REGION}" -var="replica_region=${REPLICA_REGION}" -var-file=fixtures/replication-enabled.tfvars -auto-approve

# Run full cycle commands
cycle-default: plan-default apply-default destroy-default
	@echo "Completed full cycle with default fixture"

cycle-disabled: plan-disabled apply-disabled destroy-disabled
	@echo "Completed full cycle with disabled fixture (module entirely disabled)"

cycle-replication-enabled: plan-replication-enabled apply-replication-enabled destroy-replication-enabled
	@echo "Completed full cycle with replication-enabled fixture"

# Clean up Terraform files
clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info
	@echo "Cleanup complete"
