package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestFoundationTargetDeployment deploys the foundation module in a real AWS environment
// to verify the actual resource creation and configuration.
// Note: This test requires valid AWS credentials and will create real resources.
func TestFoundationTargetDeployment(t *testing.T) {
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
		// Uncomment the following to use local state
		// BackendConfig: map[string]interface{}{
		//   "path": "./terraform.tfstate",
		// },
		EnvVars: map[string]string{
			// Uncomment and set these if needed
			// "AWS_PROFILE": "your-profile",
			// "AWS_REGION":  "us-east-1",
		},
		// Set retry options for AWS throttling
		RetryableTerraformErrors: map[string]string{
			"RequestLimitExceeded": "AWS throttling",
			"Throttling":           "AWS throttling",
		},
		MaxRetries:         5,
		TimeBetweenRetries: 5 * time.Second,
		NoColor:            true,
	}

	// Skip this test if running in short mode
	if testing.Short() {
		t.Skip("Skipping TestFoundationTargetDeployment in short mode")
	}

	// Detailed logging of module directory
	t.Logf("🔍 Terraform Target Directory: %s", terraformOptions.TerraformDir)

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Validate outputs
	kmsKeyId := terraform.Output(t, terraformOptions, "kms_key_id")
	require.NotEmpty(t, kmsKeyId, "KMS Key ID should not be empty")

	s3BucketId := terraform.Output(t, terraformOptions, "s3_bucket_id")
	require.NotEmpty(t, s3BucketId, "S3 Bucket ID should not be empty")

	cwLogGroupArn := terraform.Output(t, terraformOptions, "cloudwatch_log_group_arn")
	require.NotEmpty(t, cwLogGroupArn, "CloudWatch Log Group ARN should not be empty")

	t.Logf("💾 Resources created: KMS Key ID: %s, S3 Bucket: %s, CloudWatch Log Group: %s",
		kmsKeyId, s3BucketId, cwLogGroupArn)
}
