//go:build unit && readonly

package unit

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestInitializationOnModuleWhenUpgradeEnabled verifies that the Terraform module can be successfully initialized
// with upgrade enabled, ensuring compatibility and readiness for deployment.
func TestInitializationOnModuleWhenUpgradeEnabled(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupModuleTerraformOptions(t, dirs.GetModulesDir("default"), nil)

	t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)
}

// TestValidationOnModuleWhenBasicConfiguration ensures that the module
// passes Terraform validation checks, verifying its structural integrity.
func TestValidationOnModuleWhenBasicConfiguration(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupModuleTerraformOptions(t, dirs.GetModulesDir("default"), nil)

	t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Validate with detailed error output
	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)
}
