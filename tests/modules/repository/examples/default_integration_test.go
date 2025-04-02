package examples

import (
	"testing"
	"time"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestDeploymentOnRepositoryExampleWhenDefaultFixture verifies the behavior of the repository module
// when using the default.tfvars fixture.
func TestDeploymentOnRepositoryExampleWhenDefaultFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "repository/basic", nil)

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

	// Verify that repository resources are planned when module is enabled with default fixture
	require.Contains(t, planOutput, "aws_codeartifact_repository.this",
		"CodeArtifact repository resource should be planned when module is enabled")

	// Apply Terraform configuration
	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Verify the is_enabled output is true
	isEnabledOutput := terraform.Output(t, terraformOptions, "is_enabled")
	require.Equal(t, "true", isEnabledOutput, "The is_enabled output should be true when the module is enabled")

	// Verify repository name output
	repositoryNameOutput := terraform.Output(t, terraformOptions, "repository_name")
	require.NotEmpty(t, repositoryNameOutput, "The repository_name output should not be empty")

	// Verify domain name output
	domainNameOutput := terraform.Output(t, terraformOptions, "domain_name")
	require.NotEmpty(t, domainNameOutput, "The domain_name output should not be empty")
}
