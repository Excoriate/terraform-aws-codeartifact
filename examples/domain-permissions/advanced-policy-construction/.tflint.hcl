plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.38.0" # Use a specific version consistent with other examples/modules if possible
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# You can add specific rule configurations here if needed for the example
# rule "aws_..." {
#   enabled = false
# }
