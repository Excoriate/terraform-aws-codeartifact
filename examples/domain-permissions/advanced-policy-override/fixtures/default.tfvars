# Default fixture for the advanced-policy-override example.
# Demonstrates using policy_document_override.
# IMPORTANT: Replace '111122223333' with a valid AWS Account ID.
# IMPORTANT: Ensure the domain 'adv-override-domain' exists in the target region/account or adjust the name.
# IMPORTANT: Ensure the region 'us-west-2' in the Resource ARN matches your target region.

is_enabled = true

domain_name = "adv-override-domain" # Example domain name for this scenario

# policy_document_override is now defined directly in main.tf using a data source.

# Other variables use defaults defined in variables.tf (null/empty)
