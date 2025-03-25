package examples

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnDomainExampleWhenAllRecipesAreUsed verifies the Terraform plan generation
// for the domain basic example with all available fixture recipes.
func TestPlanningOnDomainExampleWhenAllRecipesAreUsed(t *testing.T) {
	t.Parallel()

	// Define fixtures to test
	fixtures := []string{
		"default.tfvars",
		"disabled.tfvars",
		"no-encryption.tfvars",
		"with-domain-permissions.tfvars",
		"custom-domain-owner.tfvars",
		"combined-features.tfvars",
	}

	for _, fixture := range fixtures {
		// Using local variable to ensure proper capture in closure
		fixture := fixture

		// Create a subtest for each fixture
		t.Run(fixture, func(t *testing.T) {
			t.Parallel()

			// Use helper function to setup terraform options with isolated provider cache
			terraformOptions := helper.SetupTerraformOptions(t, "domain/basic", nil)

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

			// Verify plan output according to the fixture
			if fixture == "disabled.tfvars" {
				require.NotContains(t, planOutput, "aws_codeartifact_domain.this", "Disabled fixture should not create domain")
			} else {
				// For enabled fixtures, verify domain resource is planned
				require.Contains(t, planOutput, "aws_codeartifact_domain.this", "Plan should include CodeArtifact domain resource")
			}

			// Add other specific checks based on fixture
			if fixture == "with-domain-permissions.tfvars" {
				require.Contains(t, planOutput, "aws_codeartifact_domain_permissions_policy", "Plan should include domain permissions policy")
			}

			if fixture == "custom-domain-owner.tfvars" {
				require.Contains(t, planOutput, "domain_owner", "Plan should include custom domain owner")
			}

			if fixture == "no-encryption.tfvars" {
				// Instead of looking for "encryption_key" not being present, we should check
				// for the absence of a custom KMS key resource in the plan
				require.NotContains(t, planOutput, "aws_kms_key.this", "Plan should not include custom KMS key with no-encryption fixture")
			}

			if fixture == "combined-features.tfvars" {
				require.Contains(t, planOutput, "aws_codeartifact_domain_permissions_policy", "Plan should include domain permissions policy")
				require.Contains(t, planOutput, "encryption_key", "Plan should include encryption key")
			}
		})
	}
}
