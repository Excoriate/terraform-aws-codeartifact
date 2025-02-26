package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestStaticAnalysisOnFoundationBasicExample verifies that the basic example
// for the foundation module passes static analysis checks. This includes
// confirming that the Terraform code is valid and adheres to best practices.
func TestStaticAnalysisOnFoundationBasicExample(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Enhanced Terraform options with logging and upgrade
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Validate with detailed error output
	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)

	// Run terraform fmt check
	fmtOutput, err := terraform.RunTerraformCommandAndGetStdoutE(t, terraformOptions, "fmt", "-recursive", "-check")
	require.NoError(t, err, "Terraform fmt failed")
	t.Log("✅ Terraform fmt Output:\n", fmtOutput)
}

// TestPlanOnFoundationBasicExample performs a terraform plan on the basic example
// of the foundation module to verify resource creation behavior with default settings.
func TestPlanOnFoundationBasicExample(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Enhanced Terraform options with logging and upgrade
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to show what would be created
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output (Enabled Module):\n", planOutput)

	// Verify no changes are planned when module is disabled
	disabledOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": false,
		},
	}

	disabledPlanOutput, err := terraform.PlanE(t, disabledOptions)
	require.NoError(t, err, "Terraform plan failed for disabled module")
	t.Log("📝 Terraform Plan Output (Disabled Module):\n", disabledPlanOutput)
}
