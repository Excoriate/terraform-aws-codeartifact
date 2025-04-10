###################################
# Terraform Configuration 🔧
###################################

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0" # Align with module or use appropriate constraint
    }
    # TLS provider is needed by the foundation module for OIDC thumbprint fetching
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # Align with module's constraint
    }
  }
}
