###################################
# Terraform Configuration 🔧
# ----------------------------------------------------
#
# This section defines the required Terraform and provider versions
# for this example. It ensures compatibility and consistent behavior
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
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
