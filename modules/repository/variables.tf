variable "is_enabled" {
  description = <<-DESC
  Controls whether the CodeArtifact repository and related resources are created.
  Set to `false` to disable the module entirely.
  DESC
  type        = bool
  default     = true
}

variable "domain_name" {
  description = <<-DESC
  The name of the CodeArtifact domain where the repository will be created.
  This domain must already exist.
  DESC
  type        = string
  # No default, this is mandatory.
}

variable "repository_name" {
  description = <<-DESC
  The name of the CodeArtifact repository to create.
  Repository names must be unique within a domain.
  DESC
  type        = string
  # No default, this is mandatory.
}

variable "description" {
  description = <<-DESC
  An optional description for the CodeArtifact repository.
  If not provided (`null`), no description will be set.
  DESC
  type        = string
  default     = null
}

variable "upstreams" {
  description = <<-DESC
  An optional list of upstream repositories for this repository.
  Each upstream object must contain the `repository_name` of an existing repository within the same domain.
  This is typically used for creating proxy repositories.
  Example: `[{ repository_name = "upstream-repo-1" }, { repository_name = "upstream-repo-2" }]`
  If `null`, no upstream repositories will be configured.
  DESC
  type = optional(list(object({
    repository_name = string
  })), null)
  default = null

  validation {
    condition = var.upstreams == null || alltrue([
      for upstream in var.upstreams : upstream.repository_name != null && upstream.repository_name != ""
    ])
    error_message = "Each upstream object must have a non-empty 'repository_name'."
  }
}

variable "external_connections" {
  description = <<-DESC
  An optional list of external connections for the repository.
  Valid values are strings representing predefined external connection names (e.g., "public:npmjs", "public:pypi", "public:maven-central").
  This allows the repository to fetch packages from public repositories.
  If `null`, no external connections will be configured.
  Refer to AWS CodeArtifact documentation for available external connection names.
  DESC
  type    = optional(list(string), null)
  default = null

  validation {
    # Basic validation: ensure list elements are non-empty strings if list is not null.
    # More specific validation (e.g., regex for "public:...") could be added if needed.
    condition = var.external_connections == null || alltrue([
      for conn in var.external_connections : conn != null && conn != ""
    ])
    error_message = "Each external connection name must be a non-empty string."
  }
}

variable "repository_policy_document" {
  description = <<-DESC
  An optional JSON policy document to attach to the repository as a resource policy.
  This controls permissions for accessing the repository.
  If `null`, no repository policy will be created by this module.
  DESC
  type    = optional(string, null)
  default = null

  validation {
    # Basic check if the string is likely JSON (starts with { and ends with })
    # For more robust validation, consider using `jsondecode` in a local variable,
    # but that can make planning fail if the input is invalid, which might be desired.
    condition = var.repository_policy_document == null || (substr(trimspace(var.repository_policy_document), 0, 1) == "{" && substr(trimspace(var.repository_policy_document), -1, 1) == "}")
    error_message = "The repository_policy_document must be a valid JSON string or null."
  }
}

variable "tags" {
  description = <<-DESC
  A map of tags to apply to the CodeArtifact repository resource.
  These tags will be merged with any default tags defined in the module.
  Example: `{ Environment = "production", Project = "my-app" }`
  DESC
  type        = map(string)
  default     = {}
}
