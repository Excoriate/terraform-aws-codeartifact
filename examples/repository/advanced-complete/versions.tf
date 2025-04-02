terraform {
  required_version = ">= 1.0" # Compatible with the module's requirement

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Matching the module's constraint
    }
  }
}
