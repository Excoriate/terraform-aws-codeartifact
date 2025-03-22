//go:build readonly && examples

package examples

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnExamplesBasicWhenKmsDisabledFixture verifies the Terraform plan generation
// for the basic example when using the kms-disabled fixture (only KMS key component disabled).
func TestPlanningOnExamplesBasicWhenKmsDisabledFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	// Add var files to the options
	terraformOptions.VarFiles = []string{"fixtures/kms-disabled.tfvars"}

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/kms-disabled.tfvars")

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan doesn't contain KMS resources when KMS component is disabled
	require.NotContains(t, planOutput, "aws_kms_key", "Plan should not include KMS key resource when KMS component is disabled")
	require.NotContains(t, planOutput, "aws_kms_alias", "Plan should not include KMS alias resource when KMS component is disabled")

	// But plan should still contain S3 and CloudWatch Log Group resources
	require.Contains(t, planOutput, "aws_s3_bucket", "Plan should include S3 bucket resource")
	require.Contains(t, planOutput, "aws_cloudwatch_log_group", "Plan should include CloudWatch Log Group resource")
}
