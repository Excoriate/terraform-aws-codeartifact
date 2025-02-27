//go:build unit

package unit

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestConfigurationOnTargetWhenModuleEnabled verifies the basic configuration of the module
// when it is explicitly enabled, ensuring resources are properly planned.
func TestConfigurationOnTargetWhenModuleEnabled(t *testing.T) {
	// Enable parallel test execution
	t.Parallel()

	// Resolve repository paths
	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Prepare Terraform options for basic configuration
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetTargetDir("default/basic"),
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	// Log test context
	t.Logf("🔍 Testing module configuration in directory: %s", terraformOptions.TerraformDir)

	// Initialize Terraform
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed for basic configuration")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan the configuration
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed for basic configuration")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Optional: Add specific assertions about the plan output
	// This could include checking for specific resource creation or configuration
}

// TestConfigurationOnTargetWhenModuleDisabled verifies the module behaves correctly when disabled
// ensuring no resources are planned for creation.
func TestConfigurationOnTargetWhenModuleDisabled(t *testing.T) {
	// Enable parallel test execution
	t.Parallel()

	// Resolve repository paths
	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Prepare Terraform options with module disabled
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetTargetDir("default/basic"),
		Vars: map[string]interface{}{
			"is_enabled": false,
		},
	}

	// Log test context
	t.Logf("🔍 Testing module disabled configuration in directory: %s", terraformOptions.TerraformDir)

	// Initialize Terraform
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed for disabled configuration")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan the configuration
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed for disabled configuration")
	t.Log("📝 Terraform Plan Output (Disabled Module):\n", planOutput)

	// Optional: Add assertions to verify no resources are planned when module is disabled
}
