variable "is_enabled" {
  description = <<-DESC
    Controls whether the CodeArtifact repository permissions policy is created or managed by this module.
    Set to `false` to disable the resource creation/management.
  DESC
  type        = bool
  default     = true
}

variable "domain_name" {
  description = <<-DESC
    The name of the CodeArtifact domain containing the repository. This domain must exist.
  DESC
  type        = string
  # No default - this is mandatory.

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,48}[a-z0-9]$", var.domain_name))
    error_message = "The domain name must be between 2-50 characters, contain only lowercase letters, numbers, and hyphens, cannot start or end with a hyphen."
  }
}

variable "repository_name" {
  description = <<-DESC
    The name of the CodeArtifact repository to apply the permissions policy to. This repository must exist within the specified domain.
  DESC
  type        = string
  # No default - this is mandatory.

  validation {
    condition     = length(var.repository_name) >= 2 && length(var.repository_name) <= 100 && can(regex("^[A-Za-z0-9][A-Za-z0-9._/#=+-@]*$", var.repository_name))
    error_message = "The repository name must be between 2 and 100 characters, start with a letter or number, and contain only letters, numbers, and the following characters: . _ / # = + - @"
  }
}

variable "domain_owner" {
  description = <<-DESC
    The AWS account ID that owns the domain. If not specified, the AWS account ID of the caller is used.
    Required if the domain is owned by a different account than the one applying this policy.
  DESC
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "The domain_owner must be a 12-digit AWS account ID or null."
  }
}

variable "read_principals" {
  description = <<-DESC
    A list of IAM principal ARNs (AWS accounts, users, or roles) that should be granted baseline read-only access to the repository.
    Actions typically include: `codeartifact:ReadFromRepository`, `codeartifact:GetPackageVersionReadme`, `codeartifact:GetPackageVersionAssets`, `codeartifact:ListPackageVersions`, `codeartifact:ListPackageVersionAssets`.
    Example: `["arn:aws:iam::111122223333:root", "arn:aws:iam::444455556666:role/ReadOnlyRole"]`
  DESC
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for principal in var.read_principals : can(regex("^arn:aws:iam::[0-9]{12}:(root|user/|role/).+$", principal)) || principal == "*"])
    error_message = "Each item in read_principals must be a valid IAM principal ARN (account root, user, or role) or '*'."
  }
}

variable "describe_principals" {
  description = <<-DESC
    A list of IAM principal ARNs that should be granted baseline permissions to describe/list repositories and packages.
    Actions typically include: `codeartifact:DescribeRepository`, `codeartifact:ListPackages`, `codeartifact:DescribePackageVersion`.
    Example: `["arn:aws:iam::111122223333:role/CICD"]`
  DESC
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for principal in var.describe_principals : can(regex("^arn:aws:iam::[0-9]{12}:(root|user/|role/).+$", principal)) || principal == "*"])
    error_message = "Each item in describe_principals must be a valid IAM principal ARN (account root, user, or role) or '*'."
  }
}

variable "authorization_token_principals" {
  description = <<-DESC
    A list of IAM principal ARNs that should be granted permission to get an authorization token for the domain (`codeartifact:GetAuthorizationToken`).
    This is often required for principals (especially cross-account) needing to interact with the repository endpoint using package managers.
    Example: `["arn:aws:iam::111122223333:role/DeveloperRole"]`
  DESC
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for principal in var.authorization_token_principals : can(regex("^arn:aws:iam::[0-9]{12}:(root|user/|role/).+$", principal)) || principal == "*"])
    error_message = "Each item in authorization_token_principals must be a valid IAM principal ARN (account root, user, or role) or '*'."
  }
}

variable "custom_policy_statements" {
  description = <<-DESC
    A list of custom policy statement objects to be merged into the repository policy document.
    Each object must follow the structure of an IAM policy statement.
    Required keys: `Effect` (Allow/Deny), `Action` (list of strings), `Resource` (list of strings).
    Optional keys: `Sid` (string), `Principal` (object with Type and Identifiers), `Condition` (object).
    Example:
    [
      {
        Sid    = "AllowSpecificPublish",
        Effect = "Allow",
        Principal = { Type = "AWS", Identifiers = ["arn:aws:iam::111122223333:role/PublisherRole"] },
        Action = ["codeartifact:PublishPackageVersion"],
        Resource = ["*"] # Typically "*" for repository policies, but can be more specific if needed
      }
    ]
  DESC
  type        = list(any) # Using 'any' because statement structure is complex and predefined by IAM. Validation below checks basic structure.
  default     = []

  validation {
    # Basic check for required keys in each statement object
    condition = alltrue([
      for stmt in var.custom_policy_statements :
      lookup(stmt, "Effect", null) != null && contains(["Allow", "Deny"], lookup(stmt, "Effect", "")) &&
      lookup(stmt, "Action", null) != null && try(length(lookup(stmt, "Action", [])), 0) > 0 &&
      lookup(stmt, "Resource", null) != null && try(length(lookup(stmt, "Resource", [])), 0) > 0
    ])
    error_message = "Each custom_policy_statement must be an object containing at least 'Effect' ('Allow' or 'Deny'), 'Action' (list of strings), and 'Resource' (list of strings)."
  }
}

variable "policy_revision" {
  description = <<-DESC
    The current revision of the resource policy to be set. This revision is used for optimistic locking,
    which prevents others from overwriting your changes to the repository's resource policy.
    Leave as null when creating a new policy or when optimistic locking is not needed.
  DESC
  type        = string
  default     = null
}
