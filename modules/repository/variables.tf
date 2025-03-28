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
  type = list(object({
    repository_name = string
  }))
  default = null

  validation {
    condition = var.upstreams == null ? true : alltrue([
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
  type        = list(string)
  default     = null

  validation {
    # Ensure list elements are non-empty strings matching known public connection patterns.
    condition = var.external_connections == null ? true : alltrue([
      for conn in var.external_connections : can(regex("^public:(npmjs|pypi|maven-central|maven-google-android|maven-gradle-plugin|maven-commonsware|nuget-org)$", conn))
    ])
    error_message = "Each external connection name must be a non-empty string matching a known public pattern (e.g., 'public:npmjs', 'public:pypi', etc.)."
  }
}

variable "repository_policy_document" {
  description = <<-DESC
  An optional JSON policy document to attach to the repository as a resource policy.
  This controls permissions for accessing the repository.
  If `null`, no repository policy will be created by this module.
  DESC
  type        = string
  default     = null
  sensitive   = true # Mark as sensitive to prevent exposure in logs/plan

  validation {
    # Use can(jsondecode(...)) for robust JSON structure validation during planning.
    condition     = var.repository_policy_document == null || can(jsondecode(var.repository_policy_document))
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
