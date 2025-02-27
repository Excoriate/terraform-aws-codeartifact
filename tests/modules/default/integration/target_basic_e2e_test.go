//go:build integration

package integration

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestDeploymentOnTargetWhenBasicConfigurationApplied verifies that the basic target configuration
// can be successfully deployed and creates the expected resources in AWS.
func TestDeploymentOnTargetWhenBasicConfigurationApplied(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetTargetDir("default/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	// Clean up resources when the test is complete
	defer terraform.Destroy(t, terraformOptions)

	t.Logf("🔍 Testing target deployment in directory: %s", terraformOptions.TerraformDir)

	// Initialize and apply the Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Verify outputs
	isEnabled := terraform.Output(t, terraformOptions, "module_is_enabled")
	require.Equal(t, "true", isEnabled, "Module should be enabled")

	// Additional verification could be done here, such as:
	// - Checking AWS API to confirm resources were created with correct configuration
	// - Validating resource properties match expected values
	// - Testing functionality of the created resources
}
