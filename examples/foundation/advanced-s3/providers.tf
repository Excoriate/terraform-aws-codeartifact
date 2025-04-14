###################################
# AWS Provider Configuration 🌐
# ----------------------------------------------------
# Define providers for source and replica regions
# to demonstrate cross-region replication.
###################################

provider "aws" {
  # Default provider, assumed to be the source region
  alias  = "source"
  region = var.source_region
}

provider "aws" {
  # Provider for the replica region
  alias  = "replica"
  region = var.replica_region
}
