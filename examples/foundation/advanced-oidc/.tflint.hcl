plugin "aws" {
  enabled = true
  version = "0.24.0" # Use a consistent version
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  # Disabled for local examples calling local modules
  enabled = false
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  # Disabled as examples are root modules
  enabled = false
}

# Ensure required providers are declared
rule "terraform_required_providers" {
  enabled = true
}

# Ensure required Terraform version is declared
rule "terraform_required_version" {
  enabled = true
}

# Check for unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}
