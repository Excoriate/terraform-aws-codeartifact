# Standard TFLint configuration for examples.
config {
  force = false
  # Examples are root modules, so variables should be defined.
  # module = false
}

plugin "aws" {
  enabled = true
  version = "0.38.0" # Use version consistent with module if specified, or latest compatible
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Recommended Rules (as per style guide)
rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_lookup" {
  enabled = true
}

rule "terraform_empty_list_equality" {
  enabled = true
}

rule "terraform_map_duplicate_keys" {
  enabled = true
}

# rule "terraform_module_pinned_source" { # Not applicable to root examples calling local modules
#   enabled = true
# }

# rule "terraform_module_version" { # Not applicable to root examples calling local modules
#   enabled = true
# }

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  # Often disabled in examples as not all variables might be used in every fixture
  enabled = false
}

rule "terraform_workspace_remote" {
  enabled = true
}

# Optional but recommended rules
rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}
