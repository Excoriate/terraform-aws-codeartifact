//go:build unit

package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestKMSKeyFeaturesApply tests KMS key features by applying the configuration
func TestKMSKeyFeaturesApply(t *testing.T) {
	// Skip this test if running in short mode
	if testing.Short() {
		t.Skip("Skipping TestKMSKeyFeaturesApply in short mode")
	}

	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":                  true,
			"kms_key_deletion_window":     14,
			"kms_key_enable_key_rotation": true,
		},
		RetryableTerraformErrors: map[string]string{
			"RequestLimitExceeded": "AWS throttling",
			"Throttling":           "AWS throttling",
		},
		MaxRetries:         5,
		TimeBetweenRetries: 5 * time.Second,
		NoColor:            true,
	}

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Validate KMS key outputs
	kmsKeyId := terraform.Output(t, terraformOptions, "kms_key_id")
	require.NotEmpty(t, kmsKeyId, "KMS Key ID should not be empty")
}

// TestS3BucketFeaturesApply tests S3 bucket features by applying the configuration
func TestS3BucketFeaturesApply(t *testing.T) {
	// Skip this test if running in short mode
	if testing.Short() {
		t.Skip("Skipping TestS3BucketFeaturesApply in short mode")
	}

	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":              true,
			"s3_bucket_force_destroy": true,
			"s3_bucket_versioning":    "Enabled",
		},
		RetryableTerraformErrors: map[string]string{
			"RequestLimitExceeded": "AWS throttling",
			"Throttling":           "AWS throttling",
		},
		MaxRetries:         5,
		TimeBetweenRetries: 5 * time.Second,
		NoColor:            true,
	}

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Validate S3 bucket outputs
	s3BucketId := terraform.Output(t, terraformOptions, "s3_bucket_id")
	require.NotEmpty(t, s3BucketId, "S3 Bucket ID should not be empty")
}

// TestCloudWatchLogGroupFeaturesApply tests CloudWatch log group features by applying the configuration
func TestCloudWatchLogGroupFeaturesApply(t *testing.T) {
	// Skip this test if running in short mode
	if testing.Short() {
		t.Skip("Skipping TestCloudWatchLogGroupFeaturesApply in short mode")
	}

	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":                    true,
			"cloudwatch_log_retention_days": 30,
			"cloudwatch_log_group_name":     "custom-log-group-name",
		},
		RetryableTerraformErrors: map[string]string{
			"RequestLimitExceeded": "AWS throttling",
			"Throttling":           "AWS throttling",
		},
		MaxRetries:         5,
		TimeBetweenRetries: 5 * time.Second,
		NoColor:            true,
	}

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Validate CloudWatch log group outputs
	cwLogGroupArn := terraform.Output(t, terraformOptions, "cloudwatch_log_group_arn")
	require.NotEmpty(t, cwLogGroupArn, "CloudWatch Log Group ARN should not be empty")
}

// TestKMSKeyPolicyFeatureApply tests KMS key policy feature by applying the configuration
func TestKMSKeyPolicyFeatureApply(t *testing.T) {
	// Skip this test if running in short mode
	if testing.Short() {
		t.Skip("Skipping TestKMSKeyPolicyFeatureApply in short mode")
	}

	t.Parallel()

	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Test with custom KMS key policy
	customPolicy := `{
		"Version": "2012-10-17",
		"Statement": [
			{
				"Sid": "Enable Limited IAM Root User Permissions",
				"Effect": "Allow",
				"Principal": {
					"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
				},
				"Action": [
					"kms:Create*",
					"kms:Describe*",
					"kms:Enable*",
					"kms:List*",
					"kms:Put*"
				],
				"Resource": "*"
			}
		]
	}`

	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Upgrade:      true,
		Vars: map[string]interface{}{
			"is_enabled":     true,
			"kms_key_policy": customPolicy,
		},
		RetryableTerraformErrors: map[string]string{
			"RequestLimitExceeded": "AWS throttling",
			"Throttling":           "AWS throttling",
		},
		MaxRetries:         5,
		TimeBetweenRetries: 5 * time.Second,
		NoColor:            true,
	}

	// Clean up resources at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Validate KMS key outputs
	kmsKeyId := terraform.Output(t, terraformOptions, "kms_key_id")
	require.NotEmpty(t, kmsKeyId, "KMS Key ID should not be empty")
}

func TestCrossAccountAccess(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../target/cross-account",
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Initialize and validate
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)

	// Plan and verify the changes
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Apply the changes
	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Verify outputs
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")
	require.NotEmpty(t, bucketName, "Bucket name should not be empty")

	bucketArn := terraform.Output(t, terraformOptions, "bucket_arn")
	require.NotEmpty(t, bucketArn, "Bucket ARN should not be empty")
}

func TestPolicyOverride(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../target/policy-override",
		Vars: map[string]interface{}{
			"is_enabled": true,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// Initialize and validate
	initOutput, err := terraform.InitE(t, terraformOptions)
	require.NoError(t, err, "Terraform init failed")
	t.Log("✅ Terraform Init Output:\n", initOutput)

	validateOutput, err := terraform.ValidateE(t, terraformOptions)
	require.NoError(t, err, "Terraform validate failed")
	t.Log("✅ Terraform Validate Output:\n", validateOutput)

	// Plan and verify the changes
	planOutput, err := terraform.PlanE(t, terraformOptions)
	require.NoError(t, err, "Terraform plan failed")
	t.Log("📝 Terraform Plan Output:\n", planOutput)

	// Apply the changes
	applyOutput, err := terraform.ApplyE(t, terraformOptions)
	require.NoError(t, err, "Terraform apply failed")
	t.Log("✅ Terraform Apply Output:\n", applyOutput)

	// Verify outputs
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")
	require.NotEmpty(t, bucketName, "Bucket name should not be empty")

	bucketArn := terraform.Output(t, terraformOptions, "bucket_arn")
	require.NotEmpty(t, bucketArn, "Bucket ARN should not be empty")
}
