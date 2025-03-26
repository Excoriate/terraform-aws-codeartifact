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

variable "policy_document_override" {
  description = <<-DESC
    Optional. A complete IAM policy document string (in JSON format) to override the dynamically generated policy.
    If provided (not null), this document will be used directly, and the `read_principals`, `list_repo_principals`,
    `authorization_token_principals`, and `custom_policy_statements` variables will be ignored.
  DESC
  type        = string
  default     = null

  validation {
    condition     = var.policy_document_override == null || can(jsondecode(var.policy_document_override))
    error_message = "The policy_document_override must be a valid JSON string or null."
  }
}

variable "read_principals" {
  description = <<-DESC
    (Ignored if `policy_document_override` is set)
    A list of IAM principal ARNs (AWS accounts, users, or roles) that should be granted baseline read-only access to the domain policy itself.
    Action: `codeartifact:GetDomainPermissionsPolicy`.
    Example: `["arn:aws:iam::111122223333:root"]`
  DESC
  type        = list(string)
  default     = []

  # validation {
  #   condition     = alltrue([for principal in var.read_principals : can(regex("^arn:aws:iam::[0-9]{12}:(root|user/|role/).+$", principal)) || principal == "*"])
  #   error_message = "Each item in read_principals must be a valid IAM principal ARN (account root, user, or role) or '*'."
  # }
}

variable "list_repo_principals" {
  description = <<-DESC
    (Ignored if `policy_document_override` is set)
    A list of IAM principal ARNs that should be granted baseline permissions to list repositories within the domain.
    Action: `codeartifact:ListRepositoriesInDomain`.
    Example: `["arn:aws:iam::111122223333:role/DeveloperRole"]`
  DESC
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for principal in var.list_repo_principals : can(regex("^arn:aws:iam::[0-9]{12}:(root|user/|role/).+$", principal)) || principal == "*"])
    error_message = "Each item in list_repo_principals must be a valid IAM principal ARN (account root, user, or role) or '*'."
  }
}

variable "authorization_token_principals" {
  description = <<-DESC
    (Ignored if `policy_document_override` is set)
    A list of IAM principal ARNs that should be granted permission to get an authorization token for the domain (`codeartifact:GetAuthorizationToken`).
    Also requires `sts:GetServiceBearerToken`. This is often required for principals needing to interact with repository endpoints.
    Example: `["arn:aws:iam::111122223333:role/CICDRole"]`
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
    (Ignored if `policy_document_override` is set)
    A list of custom policy statement objects to be merged into the domain policy document constructed from baseline principals.
    Each object must follow the structure of an IAM policy statement.
    Required keys: `Effect` (Allow/Deny), `Action` (list of strings), `Resource` (list of strings).
    Optional keys: `Sid` (string), `Principal` (object with Type and Identifiers), `Condition` (object).
    Example granting create repository permission:
    [
      {
        Sid    = "AllowCreateRepo",
        Effect = "Allow",
        Principal = { Type = "AWS", Identifiers = ["arn:aws:iam::111122223333:role/AdminRole"] },
        Action = ["codeartifact:CreateRepository"],
        Resource = "*" # Domain policy actions often use "*" resource
      }
    ]
  DESC
  type        = list(any)
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
