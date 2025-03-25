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
    The name of the CodeArtifact domain to add permissions to. This must reference an existing domain.

    **IMPORTANT**: The domain must already exist. This module does not create the domain,
    it only adds permissions to an existing domain.

    The domain name is used as a prefix in DNS hostnames, so it must follow DNS naming conventions:
    - Must be between 2-63 characters
    - Contain only lowercase letters, numbers, and hyphens
    - Cannot start or end with a hyphen
  DESC
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$", var.domain_name))
    error_message = "The domain name must be between 2-63 characters, contain only lowercase letters, numbers, and hyphens, cannot start with a hyphen, and cannot end with a hyphen."
  }
}

variable "domain_owner" {
  type        = string
  description = <<-DESC
    The AWS account ID that owns the domain. If not specified, the current account ID is used.

    **USE CASES**:
    - Cross-account domain management
    - Multi-account architectures
    - Organization-wide package management

    This parameter is particularly useful when you need to manage permissions for a domain owned by another account.
  DESC
  default     = null
}

variable "policy_document" {
  type        = string
  description = <<-DESC
    JSON formatted IAM policy document that controls access to the domain.

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
}

variable "policy_revision" {
  type        = string
  description = <<-DESC
    The current revision of the resource policy to be set. This revision is used for optimistic locking,
    which prevents others from overwriting your changes to the domain's resource policy.

    **USE CASES**:
    - When updating an existing policy
    - For controlled policy updates in CI/CD pipelines
    - When multiple systems might update policies

    Leave as null when creating a new policy or when you don't need optimistic locking.
  DESC
  default     = null
}