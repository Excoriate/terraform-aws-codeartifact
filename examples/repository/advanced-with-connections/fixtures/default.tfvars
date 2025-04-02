# Default fixture for the advanced-with-connections example.
# Enables the module and configures external connections.

is_enabled = true

# Configure the single external connection for this scenario
external_connection = "public:npmjs" # Changed from list to single string

# Uses default domain_name: "tf-repo-connect-domain-example"
# Uses default repository_name: "tf-repo-connect-repo-example"
# Uses default aws_region: "us-west-2"
# Uses default tags from variables.tf
