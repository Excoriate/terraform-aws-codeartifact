//go:build integration && examples

package examples

import (
	"testing"
	"time"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestDeploymentOnDomainExampleWhenDisabledFixture verifies the behavior of the domain module
// when the module is explicitly disabled using the disabled.tfvars fixture.
func TestDeploymentOnDomainExampleWhenDisabledFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "domain/basic", nil)

	// Add var file to the options for the disabled fixture
	terraformOptions.VarFiles = []string{"fixtures/disabled.tfvars"}

	// Cleanup resources when the test completes
	defer func() {
		terraform.Destroy(t, terraformOptions)
		helper.WaitForResourceDeletion(t, 2*time.Second)
	}()

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/disabled.tfvars")

	// Initialize Terraform
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan Terraform configuration
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify no resources are planned when module is disabled
	require.NotContains(t, planOutput, "aws_codeartifact_domain.this",
		"No CodeArtifact domain resource should be planned when module is disabled")

	// Apply Terraform configuration (which should create no resources)
	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Verify the is_enabled output is false
	isEnabledOutput := terraform.Output(t, terraformOptions, "is_enabled")
	require.Equal(t, "false", isEnabledOutput, "The is_enabled output should be false when the module is disabled")
}
