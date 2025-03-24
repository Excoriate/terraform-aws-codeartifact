variable "is_enabled" {
  type        = bool
  description = <<-DESC
    Controls whether module resources should be created or not. This is used to enable/disable the module
    and all of its resources. Set to `false` to disable all resources in this module. Default is `true`.

    **IMPORTANT**: Setting this to `false` will effectively disable the entire module and all its resources.
    This is useful for scenarios where you want to conditionally enable or disable a whole module.
  DESC
  default     = true
}

variable "domain_name" {
  type        = string
  description = <<-DESC
    The name of the CodeArtifact domain to create. All domain names in an AWS Region that are in the same
    AWS account must be unique. The domain name is used as the prefix in DNS hostnames.

    **NAMING CONSTRAINTS**:
    - Must be unique in your AWS account within an AWS Region
    - Length between 2-50 characters
    - Can contain lowercase letters, numbers, and hyphens
    - Cannot start with a hyphen
    - Cannot contain underscores, spaces, or any other special characters

    **SECURITY NOTE**: Do not use sensitive information in a domain name because it is publicly discoverable.
  DESC
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,48}[a-z0-9]$", var.domain_name))
    error_message = "The domain name must be between 2-50 characters, contain only lowercase letters, numbers, and hyphens, cannot start with a hyphen, and cannot end with a hyphen."
  }
}

variable "kms_key_arn" {
  type        = string
  description = <<-DESC
    The ARN of the KMS key used to encrypt the domain's assets. This key must be created in the foundation
    layer and passed to this module. If not provided, AWS will use the default aws/codeartifact AWS KMS key.

    **KEY REQUIREMENTS**:
    - Must be a valid KMS key ARN
    - Must be in the same region as the CodeArtifact domain
    - Must have the necessary permissions to be used by CodeArtifact

    **SECURITY RECOMMENDATION**:
    It is strongly recommended to use a customer-managed KMS key for production environments
    to have full control over encryption and key rotation policies.
  DESC
  default     = null
}

variable "domain_owner" {
  type        = string
  description = <<-DESC
    The AWS account ID that owns the domain. Typically this is your own account ID, but this parameter
    allows cross-account domain configuration. If not specified, the current account ID is used.

    **USE CASES**:
    - Cross-account domain sharing
    - Multi-account architectures
    - Organization-wide package management

    This parameter is particularly useful when you want to reference a domain owned by another account.
  DESC
  default     = null
}

variable "enable_domain_permissions_policy" {
  type        = bool
  description = <<-DESC
    Controls whether to create a domain permissions policy. Set to `true` to create a permissions policy
    for the domain. Default is `false`.

    **NOTE**: This is separate from the module-level `is_enabled` flag and allows for more granular control
    over which specific resources are created within the module.
  DESC
  default     = false
}

variable "domain_permissions_policy" {
  type        = string
  description = <<-DESC
    JSON formatted IAM policy document that controls access to the domain. This policy is applied only if
    `enable_domain_permissions_policy` is set to `true`.

    **POLICY REQUIREMENTS**:
    - Must be a valid IAM policy document in JSON format
    - Should follow least privilege principles
    - Consider policies that grant specific permissions to specific principals

    **EXAMPLE POLICY**:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "codeartifact:ReadFromRepository",
            "codeartifact:DescribeRepository",
            "codeartifact:ListRepositories"
          ],
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::123456789012:role/DeveloperRole"
          },
          "Resource": "*"
        }
      ]
    }
    ```
  DESC
  default     = null
}

variable "tags" {
  type        = map(string)
  description = <<-DESC
    A map of tags to assign to all resources created by this module. These tags will be applied
    to all resources that support tagging.

    **TAGGING STRATEGY**:
    - Use consistent tag keys across your infrastructure
    - Consider including environment, project, owner, and cost center tags
    - Follow your organization's tagging standards

    **NOTE**: Tags defined here will be merged with any default tags defined at the provider level.
  DESC
  default     = {}
}
