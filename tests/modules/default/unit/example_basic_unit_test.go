//go:build unit

package unit

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnExamplesWhenModuleEnabled verifies the Terraform plan generation
// for the basic example when the module is explicitly enabled.
func TestPlanningOnExamplesWhenModuleEnabled(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	t.Logf("🔍 Terraform Examples Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to show what would be created in examples
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify no changes are planned when module is disabled
	disabledOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": false,
		},
	}

	disabledPlanOutput, err := terraform.PlanE(t, disabledOptions)
	require.NoError(t, err, "Terraform plan failed for disabled module")
	t.Log("📝 Terraform Plan Output (Disabled Module):\n", disabledPlanOutput)

	// Cleanup resources after test
	terraform.Destroy(t, terraformOptions)
}
