variable "is_enabled" {
  description = "Master flag to enable/disable the example resources."
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region where the resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Name for the CodeArtifact domain created directly in this example."
  type        = string
  default     = "dpca-basic-domain-example"
}

variable "role_name" {
  description = "Name for the IAM role to be created in the domain owner's account."
  type        = string
  default     = "dpca-basic-role-example"
}

variable "role_description" {
  description = "Description for the IAM role."
  type        = string
  default     = "IAM role for cross-account CodeArtifact domain access"
}

variable "role_path" {
  description = "Path for the IAM role."
  type        = string
  default     = "/"
}

variable "external_principals" {
  description = "List of external AWS principals (object form) allowed to assume the cross-account IAM role."
  type = list(object({
    account_id = string
    role_name  = string
  }))
  default = [
    {
      account_id = "111122223333"
      role_name  = "dpca-basic-role-example"
    },
    {
      account_id = "444455556666"
      role_name  = "dpca-basic-role-example"
    }
  ]
}

variable "external_principals_arns_override" {
  description = "List of full ARNs of external AWS principals (roles) allowed to assume the cross-account IAM role. Takes precedence if set."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default = {
    Environment = "example"
    Project     = "domain-permissions-cross-account-basic"
    ManagedBy   = "terraform"
  }
}
