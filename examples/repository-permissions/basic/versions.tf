terraform {
  required_version = ">= 1.0" # Or align with repository-permissions module if stricter

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Align with repository-permissions module
    }
  }
}
