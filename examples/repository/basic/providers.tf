provider "aws" {
  region = var.region
  # Default tags can be configured here as well, but often tags are managed
  # via variables passed into the module for consistency.
  # default_tags {
  #   tags = {
  #     Example     = "basic-repository"
  #     Environment = "development"
  #     ManagedBy   = "Terraform"
  #   }
  # }
}
