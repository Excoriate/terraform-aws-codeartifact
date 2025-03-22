//go:build unit && readonly

package unit

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnTargetWhenModuleDisabled verifies the Terraform plan generation
// for the disabled_module target configuration when the module is explicitly disabled.
func TestPlanningOnTargetWhenModuleDisabled(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTargetTerraformOptions(t, "default", "disabled_module", nil)

	t.Logf("🔍 Terraform Target Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to show what would be created in the disabled_module target
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan does not contain the random_string resource
	require.NotContains(t, planOutput, "random_string.random_text", "Plan should not include random_string resource when module is disabled")
}

// TestOutputsOnTargetWhenModuleDisabled verifies that the module outputs
// are correctly set when the module is disabled.
func TestOutputsOnTargetWhenModuleDisabled(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTargetTerraformOptions(t, "default", "disabled_module", nil)

	t.Logf("🔍 Terraform Target Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to show what would be created in the disabled_module target
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan contains the expected outputs
	require.Contains(t, planOutput, "is_enabled = false", "Plan should show is_enabled output as false")
}
