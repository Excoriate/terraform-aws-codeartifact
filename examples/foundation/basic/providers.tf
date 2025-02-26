###################################
# Provider Configuration 🔌
# ----------------------------------------------------
#
# This section configures the AWS provider for this example.
# It specifies the region and default tags to apply to all resources.
#
###################################

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Example    = "foundation-basic"
      Repository = "terraform-aws-codeartifact"
    }
  }
}

provider "random" {
  # No configuration needed for the random provider
}
