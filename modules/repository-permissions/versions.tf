terraform {
  required_version = ">= 1.0" # Or a more specific minimum version if needed

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Align with other modules
    }
  }
}
