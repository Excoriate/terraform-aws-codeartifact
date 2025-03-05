//go:build readonly,examples

package examples

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnExamplesBasicWhenDisabledFixture verifies the Terraform plan generation
// for the basic example when using the disabled fixture (module entirely disabled).
func TestPlanningOnExamplesBasicWhenDisabledFixture(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		VarFiles:     []string{"fixtures/disabled.tfvars"},
	}

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/disabled.tfvars")

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan doesn't contain resources when module is disabled
	require.NotContains(t, planOutput, "aws_kms_key", "Plan should not include KMS key resource when module is disabled")
	require.NotContains(t, planOutput, "aws_s3_bucket", "Plan should not include S3 bucket resource when module is disabled")
	require.NotContains(t, planOutput, "aws_cloudwatch_log_group", "Plan should not include CloudWatch Log Group resource when module is disabled")
}
