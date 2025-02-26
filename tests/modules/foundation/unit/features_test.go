package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestKMSKeyFeatures verifies the KMS key features of the foundation module
func TestKMSKeyFeatures(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Test with custom KMS key configuration
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":                  true,
			"kms_key_deletion_window":     14,
			"kms_key_enable_key_rotation": true,
		},
	}

	// Detailed logging of module directory
	t.Logf("🔍 Testing KMS Key Features in: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to verify configuration settings
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output (Custom KMS Config):\n", planOutput)

	// Verify plan contains the custom settings
	require.Contains(t, planOutput, "key_rotation_enabled", "Plan should include key rotation configuration")
	require.Contains(t, planOutput, "deletion_window_in_days", "Plan should include deletion window configuration")
}

// TestS3BucketFeatures verifies the S3 bucket features of the foundation module
func TestS3BucketFeatures(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Test with custom S3 bucket configuration
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":              true,
			"s3_bucket_force_destroy": true,
			"s3_bucket_versioning":    "Enabled",
		},
	}

	// Detailed logging of module directory
	t.Logf("🔍 Testing S3 Bucket Features in: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to verify configuration settings
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output (Custom S3 Config):\n", planOutput)

	// Verify plan contains the custom settings
	require.Contains(t, planOutput, "force_destroy", "Plan should include force_destroy configuration")
	require.Contains(t, planOutput, "versioning", "Plan should include versioning configuration")
}

// TestCloudWatchLogGroupFeatures verifies the CloudWatch log group features of the foundation module
func TestCloudWatchLogGroupFeatures(t *testing.T) {
	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Test with custom CloudWatch log group configuration
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":                    true,
			"cloudwatch_log_retention_days": 30,
			"cloudwatch_log_group_name":     "custom-log-group-name",
		},
	}

	// Detailed logging of module directory
	t.Logf("🔍 Testing CloudWatch Log Group Features in: %s", terraformOptions.TerraformDir)

	// Initialize with detailed error handling
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	// Plan to verify configuration settings
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output (Custom CloudWatch Config):\n", planOutput)

	// Verify plan contains the custom settings
	require.Contains(t, planOutput, "retention_in_days", "Plan should include retention days configuration")
	require.Contains(t, planOutput, "custom-log-group-name", "Plan should include custom log group name")
}
