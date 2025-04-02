terraform {
  required_version = ">= 1.0" # Specify a broader range or pin to a specific version as needed

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use the latest appropriate 5.x version
    }
  }
}
