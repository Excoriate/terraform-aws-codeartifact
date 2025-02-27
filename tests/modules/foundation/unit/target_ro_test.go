//go:build unit && readonly

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestFoundationTargetDeploymentReadOnly performs read-only validation of the foundation module
// without actually creating resources. This test focuses on configuration validation.
func TestFoundationTargetDeploymentReadOnly(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetModulesDir("foundation/target/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
			"aws_region": "us-east-1", // Adjust as needed
		},
		NoColor: true,
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Target Directory (Read-Only): %s", terraformOptions.TerraformDir)

	// Initialize and validate
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Perform a plan operation (read-only)
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Validate plan contains expected configurations
	require.Contains(t, planOutput, "aws_kms_key", "Plan should include KMS key resource")
	require.Contains(t, planOutput, "aws_s3_bucket", "Plan should include S3 bucket resource")
	require.Contains(t, planOutput, "aws_cloudwatch_log_group", "Plan should include CloudWatch log group resource")

	// Optional: Add specific configuration checks
	require.Contains(t, planOutput, "us-east-1", "Plan should reference specified region")
	require.Contains(t, planOutput, "is_enabled = true", "Plan should respect enabled flag")
}

// TestFoundationTargetConfigurationValidation performs additional configuration validation
func TestFoundationTargetConfigurationValidation(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetModulesDir("foundation/target/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled": true,
			"aws_region": "us-east-1",
			// Add additional configuration variations for validation
			"kms_key_deletion_window":  7,
			"log_group_retention_days": 30,
		},
		NoColor: true,
	}

	// Initialize and validate
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Perform a plan operation (read-only)
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Validate specific configuration details
	require.Contains(t, planOutput, "deletion_window_in_days = 7", "Plan should include custom KMS key deletion window")
	require.Contains(t, planOutput, "retention_in_days = 30", "Plan should include custom log group retention days")
}
