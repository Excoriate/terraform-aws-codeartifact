//go:build readonly && examples

package examples

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
)

// TestInitializationOnExamplesBasicWhenAllFeaturesEnabled verifies that the basic example
// with all features enabled can be successfully initialized.
func TestInitializationOnExamplesBasicWhenAllFeaturesEnabled(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)
}

// TestValidationOnExamplesBasicWhenAllFeaturesEnabled ensures that the basic example
// with all features enabled passes Terraform validation checks.
func TestValidationOnExamplesBasicWhenAllFeaturesEnabled(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)
}

// TestPlanningOnExamplesBasicWhenDefaultFixture verifies the Terraform plan generation
// for the basic example when using the default fixture (all components enabled).
func TestPlanningOnExamplesBasicWhenDefaultFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	// Add var files to the options
	terraformOptions.VarFiles = []string{"fixtures/default.tfvars"}

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/default.tfvars")

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan contains expected resources
	require.Contains(t, planOutput, "aws_kms_key", "Plan should include KMS key resource")
	require.Contains(t, planOutput, "aws_kms_alias", "Plan should include KMS alias resource")
	require.Contains(t, planOutput, "aws_s3_bucket", "Plan should include S3 bucket resource")
	require.Contains(t, planOutput, "aws_cloudwatch_log_group", "Plan should include CloudWatch Log Group resource")
}

// TestFormatCheckOnExamplesBasicWhenAllFeaturesEnabled verifies that the
// Terraform code in the basic example follows formatting standards.
func TestFormatCheckOnExamplesBasicWhenAllFeaturesEnabled(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	t.Logf("🔍 Checking Terraform formatting in: %s", terraformOptions.TerraformDir)

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Run terraform fmt check in the directory
	fmtOutput, err := terraform.RunTerraformCommandAndGetStdoutE(
		t,
		terraformOptions,
		"fmt", "-recursive", "-check",
	)

	// If err is nil, the check passed (no formatting needed)
	// If err is not nil, the check failed (formatting issues found)
	if err != nil {
		t.Logf("❌ Terraform fmt check found formatting issues:\n%s", fmtOutput)
		t.Fail()
	} else {
		t.Log("✅ Terraform fmt check passed")
	}
}
