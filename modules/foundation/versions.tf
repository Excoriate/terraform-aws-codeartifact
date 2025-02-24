###################################
# Terraform Configuration 🔧
# ----------------------------------------------------
#
# This section defines the required Terraform and provider versions
# for this module. It ensures compatibility and consistent behavior
# across different environments.
#
###################################

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}
