# Disabled fixture: Disables the entire foundation module call.
# No resources should be created by the module itself when using this fixture.
# Note: Resources created directly in the example's main.tf (like replica bucket/role)
# are NOT controlled by this flag and would still be created unless
# the example's main.tf also includes conditional logic based on var.is_enabled.
# For simplicity, this example's main.tf does not add that extra layer.

is_enabled = false
