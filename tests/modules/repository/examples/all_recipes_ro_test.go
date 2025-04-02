package examples

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnRepositoryExampleWhenAllRecipesAreUsed verifies the Terraform plan generation
// for the repository basic example with all available fixture recipes.
func TestPlanningOnRepositoryExampleWhenAllRecipesAreUsed(t *testing.T) {
	t.Parallel()

	// Define fixtures to test
	fixtures := []string{
		"default.tfvars",
		"disabled.tfvars",
	}

	for _, fixture := range fixtures {
		// Using local variable to ensure proper capture in closure
		fixture := fixture

		// Create a subtest for each fixture
		t.Run(fixture, func(t *testing.T) {
			t.Parallel()

			// Use helper function to setup terraform options with isolated provider cache
			terraformOptions := helper.SetupTerraformOptions(t, "repository/basic", nil)

			// Add Upgrade=true to ensure modules are installed during init
			terraformOptions.Upgrade = true

			// Add var file to the options
			terraformOptions.VarFiles = []string{"fixtures/" + fixture}

			t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
			t.Logf("📝 Using fixture: fixtures/%s", fixture)

			initOutput, err := terraform.InitE(t, terraformOptions)
			require.NoError(t, err, "Terraform init failed")
			t.Log("✅ Terraform Init Output:\n", initOutput)

			planOutput, err := terraform.PlanE(t, terraformOptions)
			require.NoError(t, err, "Terraform plan failed")
			t.Log("📝 Terraform Plan Output:\n", planOutput)

			// No assertions on plan content - we just want to verify the plan succeeds
		})
	}
}

// TestPlanningOnAdvancedRepositoryExamplesWhenActive verifies the Terraform plan generation
// for all advanced repository examples.
func TestPlanningOnAdvancedRepositoryExamplesWhenActive(t *testing.T) {
	t.Parallel()

	// Define examples to test
	examples := []string{
		"repository/advanced-with-upstream",
		"repository/advanced-with-policies",
		"repository/advanced-with-connections",
		"repository/advanced-complete",
	}

	fixtures := []string{
		"default.tfvars",
		"disabled.tfvars",
	}

	for _, examplePath := range examples {
		// Using local variable to ensure proper capture in closure
		examplePath := examplePath

		for _, fixture := range fixtures {
			// Using local variable to ensure proper capture in closure
			fixture := fixture

			// Create a subtest for each example and fixture combination
			testName := examplePath + "-" + fixture
			t.Run(testName, func(t *testing.T) {
				t.Parallel()

				// Use helper function to setup terraform options with isolated provider cache
				terraformOptions := helper.SetupTerraformOptions(t, examplePath, nil)

				// Add Upgrade=true to ensure modules are installed during init
				terraformOptions.Upgrade = true

				// Add var file to the options
				terraformOptions.VarFiles = []string{"fixtures/" + fixture}

				t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
				t.Logf("📝 Using fixture: fixtures/%s", fixture)

				// Initialize Terraform - verify this succeeds
				initOutput, err := terraform.InitE(t, terraformOptions)
				require.NoError(t, err, "Terraform init failed")
				t.Log("✅ Terraform Init Output:\n", initOutput)

				// Plan Terraform configuration - just verify the plan succeeds
				planOutput, err := terraform.PlanE(t, terraformOptions)
				require.NoError(t, err, "Terraform plan failed")
				t.Log("📝 Terraform Plan Output:\n", planOutput)

				// No assertions on plan content - we just want to verify the plan succeeds
			})
		}
	}
}
