//go:build integration && examples

package examples

import (
	"testing"
	"time"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestDeploymentOnExamplesBasicWhenDisabledFixture verifies the full deployment of
// the basic example with the disabled fixture (module entirely disabled).
func TestDeploymentOnExamplesBasicWhenDisabledFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	// Add var files to the options
	terraformOptions.VarFiles = []string{"fixtures/disabled.tfvars"}

	// Cleanup resources when the test completes
	defer func() {
		terraform.Destroy(t, terraformOptions)
		helper.WaitForResourceDeletion(t, 10*time.Second)
	}()

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/disabled.tfvars")

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs from Terraform
	isEnabledStr := terraform.Output(t, terraformOptions, "is_enabled")
	isEnabled := isEnabledStr == "true"

	// Verify the module is disabled
	assert.False(t, isEnabled, "Expected module to be disabled with is_enabled=false")

	// Verify feature flags
	featureFlags := terraform.OutputMap(t, terraformOptions, "feature_flags")
	assert.Equal(t, "false", featureFlags["is_enabled"], "Expected is_enabled feature flag to be false")
	assert.Equal(t, "false", featureFlags["is_kms_key_enabled"], "Expected is_kms_key_enabled feature flag to be false")
	assert.Equal(t, "false", featureFlags["is_s3_bucket_enabled"], "Expected is_s3_bucket_enabled feature flag to be false")
	assert.Equal(t, "false", featureFlags["is_log_group_enabled"], "Expected is_log_group_enabled feature flag to be false")

	// Verify outputs for resources are empty when module is disabled
	outputs := []string{
		"kms_key_arn",
		"kms_key_id",
		"s3_bucket_id",
		"log_group_name",
	}

	for _, output := range outputs {
		value, err := terraform.OutputE(t, terraformOptions, output)
		if err == nil {
			assert.Empty(t, value, "Expected output %q to be empty when module is disabled", output)
		} else {
			// If the output isn't defined in disabled state, that's also acceptable
			t.Logf("Output %q is not available when module is disabled (expected behavior)", output)
		}
	}
}
