//go:build unit && readonly

package unit

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestValidationOnExamplesWhenBasicConfigurationLoaded ensures that the basic example
// configuration passes Terraform validation checks, verifying its structural integrity.
func TestValidationOnExamplesWhenBasicConfigurationLoaded(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Enhanced Terraform options with logging and upgrade
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("default/basic"),
		Upgrade:      true,
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Module Directory: %s", terraformOptions.TerraformDir)

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
