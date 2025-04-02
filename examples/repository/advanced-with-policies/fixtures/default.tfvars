# Default fixture for the advanced-with-policies example.
# Enables the module and demonstrates policy creation using defaults.

is_enabled = true

# Uses default domain_name: "tf-repo-policy-domain-example"
# Uses default repository_name: "tf-repo-policy-repo-example"
# Uses default aws_region: "us-west-2"
# Uses default tags from variables.tf

# policy_principal_arn is left as null (default) to use the current caller identity.
# policy_principal_arn = "arn:aws:iam::111122223333:user/some-user" # Example override

# create_policy defaults to true in variables.tf for this example.
