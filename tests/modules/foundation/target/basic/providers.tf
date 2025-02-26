###################################
# Provider Configuration
###################################

provider "aws" {
  region = "us-east-1" # Default region for tests

  # Uncomment to use a specific profile
  # profile = "your-profile"

  default_tags {
    tags = {
      Testing   = "true"
      Terraform = "true"
    }
  }
}

provider "random" {}
