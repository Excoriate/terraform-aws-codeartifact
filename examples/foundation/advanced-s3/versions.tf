###################################
# Terraform Configuration 🔧
# ----------------------------------------------------
# Define required Terraform and provider versions
# for this example.
###################################

terraform {
  required_version = ">= 1.10.0" # Align with module requirement

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0" # Align with module requirement
    }
    # TLS provider is needed by the foundation module for OIDC thumbprint fetching
    # Include it here even if OIDC is disabled by default in this example,
    # as fixtures might enable it.
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # Align with module's constraint
    }
  }
}
