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

variable "role_name" {
  type        = string
  description = <<-DESC
    The name for the IAM role to be created in the domain owner's account. This role will be assumed by external AWS principals.

    **Constraints:**
    - Must be unique within the AWS account.
    - Should be descriptive of its cross-account purpose.

    **Example:**
    "codeartifact-cross-account-access"

    **References:**
    - [AWS IAM Role Naming](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
  DESC
  # No default - this is mandatory.
}

variable "role_description" {
  type        = string
  description = "Description of the IAM role."
  default     = "IAM role for cross-account CodeArtifact domain access"
}

variable "role_path" {
  type        = string
  description = "Path for the IAM role. Defaults to '/'."
  default     = "/"
}

variable "external_principals_arns_override" {
  type        = list(string)
  description = <<-DESC
    List of full ARNs of external AWS principals (roles) allowed to assume the cross-account IAM role.
    If this is set, it'll take precedence over the `external_principals` variable.

    **Example:**
    external_principals_arns_override = [
      "arn:aws:iam::112487888422:role/dev-tools-prod-ro",
      "arn:aws:iam::112487888422:role/dev-tools-dev-pu",
    ]
  DESC
  default     = []
}

variable "external_principals" {
  type = list(object({
    account_id = string
    role_name  = string
  }))
  description = <<-DESC
    List of external AWS principals (roles) allowed to assume the cross-account IAM role. Each object must specify:
    - `account_id`: The external AWS account ID.
    - `role_name`: The role name in the external account allowed to assume the role.

    **Example:**
    external_principals = [
      { account_id = "122345678901", role_name = "test-tools-prod-ro" },
      { account_id = "122345678901", role_name = "test-tools-dev-pu" },
    ]

    **References:**
    - [AWS IAM Role Trust Relationships](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_modify.html#roles-modify_trust-policy)
  DESC
}

variable "iam_role_cross_account_policies" {
  type = list(object({
    name        = string
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform")
    policy      = string # Expecting JSON string content directly
  }))
  description = <<-DESC
    List of IAM policies to create and attach to the cross-account role. Each object must specify:
    - `name`: The name of the IAM policy.
    - `policy`: The policy document as a JSON formatted string. Use `jsonencode()` or `file()` to provide this.
    - `path`: (Optional) The path for the policy. Defaults to "/".
    - `description`: (Optional) The description of the policy.

    **Example:**
    iam_role_cross_account_policies = [
      {
        name   = "CodeArtifactReadOnlyAccess"
        policy = jsonencode({ Version = "2012-10-17", Statement = [...] })
      },
      {
        name   = "CodeArtifactGetToken"
        policy = file("policies/get-token.json")
      }
    ]
  DESC
  default     = []

  validation {
    condition = alltrue([
      for p in var.iam_role_cross_account_policies : can(jsondecode(p.policy))
    ])
    error_message = "The 'policy' attribute for each item in 'policies' must be a valid JSON string."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 3600 (1 hour) to 43200 (12 hours)."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "The maximum session duration must be between 3600 and 43200 seconds."
  }
}

variable "force_detach_policies" {
  type        = bool
  description = "Specifies whether to force detaching any policies the role has before destroying it. Defaults to false."
  default     = false
}

variable "default_policy_path" {
  type        = string
  description = "Default path for policies created by this module if not specified in the `policies` variable. Defaults to '/'."
  default     = "/"
}

variable "default_policy_desc" {
  type        = string
  description = "Default description for policies created by this module if not specified in the `policies` variable."
  default     = "Managed by Terraform"
}

variable "tags" {
  type        = map(string)
  description = <<-DESC
    Optional tags to apply to the IAM role and policies. These tags help with resource organization, cost allocation, and compliance.

    **Example:**
    {
      Environment = "production"
      Project     = "codeartifact-cross-account"
      ManagedBy   = "Terraform"
    }

    **References:**
    - [AWS Tagging Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html)
  DESC
  default     = {}
}
