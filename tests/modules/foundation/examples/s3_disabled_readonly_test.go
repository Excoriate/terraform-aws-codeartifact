// go:build readonly,examples

package examples

import (
	"testing"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestPlanningOnExamplesBasicWhenS3DisabledFixture verifies the Terraform plan generation
// for the basic example when using the s3-disabled fixture (only S3 bucket component disabled).
func TestPlanningOnExamplesBasicWhenS3DisabledFixture(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		VarFiles:     []string{"fixtures/s3-disabled.tfvars"},
	}

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/s3-disabled.tfvars")

	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Verify plan doesn't contain S3 resources when S3 component is disabled
	require.NotContains(t, planOutput, "aws_s3_bucket", "Plan should not include S3 bucket resource when S3 component is disabled")
	require.NotContains(t, planOutput, "aws_s3_bucket_policy", "Plan should not include S3 bucket policy resource when S3 component is disabled")

	// But plan should still contain KMS and CloudWatch Log Group resources
	require.Contains(t, planOutput, "aws_kms_key", "Plan should include KMS key resource")
	require.Contains(t, planOutput, "aws_cloudwatch_log_group", "Plan should include CloudWatch Log Group resource")
}
