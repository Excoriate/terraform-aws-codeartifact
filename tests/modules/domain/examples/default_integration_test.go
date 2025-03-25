package examples

import (
	"testing"
	"time"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestDeploymentOnDomainExampleWhenDefaultFixture verifies the behavior of the domain module
// when using the default.tfvars fixture.
func TestDeploymentOnDomainExampleWhenDefaultFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "domain/basic", nil)

	// Add var file to the options for the default fixture
	terraformOptions.VarFiles = []string{"fixtures/default.tfvars"}

	// Cleanup resources when the test completes
	defer func() {
		terraform.Destroy(t, terraformOptions)
		helper.WaitForResourceDeletion(t, 7*time.Second)
	}()

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/default.tfvars")

	// Initialize Terraform
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan Terraform configuration
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify that resources are planned when module is enabled with default fixture
	require.Contains(t, planOutput, "aws_codeartifact_domain.this",
		"CodeArtifact domain resource should be planned when module is enabled")

	// Apply Terraform configuration
	// Apply Terraform configuration
	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Verify the is_enabled output is true
	isEnabledOutput := terraform.Output(t, terraformOptions, "is_enabled")
	require.Equal(t, "true", isEnabledOutput, "The is_enabled output should be true when the module is enabled")
}
