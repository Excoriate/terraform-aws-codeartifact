###################################
# Example Variables 📝
# ----------------------------------------------------
#
# This file defines variables that could be customized for
# different environments or use cases. For this basic example,
# we're using default values directly in the main.tf file.
#
###################################

# No variables are defined for this basic example as all values
# are hardcoded in the main.tf file for simplicity.
# In a real-world scenario, you would define variables here and
# use them in main.tf to make the configuration more flexible.

variable "is_enabled" {
  description = "Whether the module is enabled or not"
  type        = bool
  default     = true
}

# Additional variables can be defined here as needed
# for more complex examples or use cases.
