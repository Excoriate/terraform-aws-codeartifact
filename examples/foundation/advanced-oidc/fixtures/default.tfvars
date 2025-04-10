# Default fixture for the Advanced OIDC example.
# This fixture typically keeps OIDC disabled to test the core foundation resources.
# It relies on the default values set in variables.tf for most settings.

is_oidc_provider_enabled = false

# You can override other defaults here if needed for the 'default' test case, e.g.:
# kms_key_alias            = "alias/my-adv-default-key"
# log_group_name           = "/aws/codeartifact/my-adv-default-logs"
# s3_bucket_name           = "my-adv-default-bucket-unique-name"
# codeartifact_domain_name = "my-adv-default-domain"
