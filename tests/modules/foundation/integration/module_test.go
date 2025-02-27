//go:build integration

package integration

import (
	"context"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// TestKMSKeyCreationAndDeletion validates that a KMS key is created, properly
// configured with key rotation enabled, and can be deleted.
func TestKMSKeyCreationAndDeletion(t *testing.T) {
	t.Parallel()

	// Skip if running in short mode
	if testing.Short() {
		t.Skip("Skipping integration test in short mode")
	}

	// Setup AWS clients
	kmsClient, _, _ := setupAWSClients(t)

	// Generate a unique key alias for the test
	keyAlias := helper.GenerateUniqueResourceName("test-key")

	// Get test directory
	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Configure Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/basic"),
		Vars: map[string]interface{}{
			"is_enabled":           true,
			"domain_name":          helper.GenerateUniqueResourceName("test-domain"),
			"force_destroy_domain": true,
			"kms_key_alias":        keyAlias,
			"enable_key_rotation":  true,
		},
	}

	// Clean up resources when the test completes
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Get KMS key ID from Terraform output
	keyId := terraform.Output(t, terraformOptions, "kms_key_id")
	require.NotEmpty(t, keyId, "KMS key ID should not be empty")

	// Validate KMS key exists and is enabled
	describeKeyOutput, err := kmsClient.DescribeKey(context.TODO(), &kms.DescribeKeyInput{
		KeyId: &keyId,
	})
	require.NoError(t, err, "Failed to describe KMS key")
	require.NotNil(t, describeKeyOutput.KeyMetadata, "Key metadata should not be nil")
	require.Equal(t, keyId, *describeKeyOutput.KeyMetadata.KeyId, "Key ID should match")
	require.True(t, describeKeyOutput.KeyMetadata.Enabled, "Key should be enabled")

	// Validate key rotation is enabled
	getKeyRotationStatusOutput, err := kmsClient.GetKeyRotationStatus(context.TODO(), &kms.GetKeyRotationStatusInput{
		KeyId: &keyId,
	})
	require.NoError(t, err, "Failed to get key rotation status")
	require.True(t, getKeyRotationStatusOutput.KeyRotationEnabled, "Key rotation should be enabled")
}

// TestS3BucketCreationAndDeletion validates that an S3 bucket is created, properly
// configured with versioning enabled, and can be deleted.
func TestS3BucketCreationAndDeletion(t *testing.T) {
	t.Parallel()

	// Skip if running in short mode
	if testing.Short() {
		t.Skip("Skipping integration test in short mode")
	}

	// Setup AWS clients
	_, s3Client, _ := setupAWSClients(t)

	// Generate a unique bucket name for the test
	bucketName := helper.GenerateUniqueResourceName("test-bucket")

	// Get test directory
	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Configure Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: dirs.GetExamplesDir("foundation/complete"),
		Vars: map[string]interface{}{
			"is_enabled":           true,
			"domain_name":          helper.GenerateUniqueResourceName("test-domain"),
			"force_destroy_domain": true,
			"s3_bucket_name":       bucketName,
			"enable_versioning":    true,
		},
	}

	// Clean up resources when the test completes
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Get bucket name from Terraform output
	outputBucketName := terraform.Output(t, terraformOptions, "s3_bucket_name")
	require.Equal(t, bucketName, outputBucketName, "Bucket name output should match input")

	// Validate bucket exists
	_, err = s3Client.HeadBucket(context.TODO(), &s3.HeadBucketInput{
		Bucket: &bucketName,
	})
	require.NoError(t, err, "Failed to head S3 bucket")

	// Validate bucket versioning is enabled
	getBucketVersioningOutput, err := s3Client.GetBucketVersioning(context.TODO(), &s3.GetBucketVersioningInput{
		Bucket: &bucketName,
	})
	require.NoError(t, err, "Failed to get bucket versioning")
	require.Equal(t, types.BucketVersioningStatusEnabled, getBucketVersioningOutput.Status, "Bucket versioning should be enabled")

	// Wait for resource deletion to propagate
	defer helper.WaitForResourceDeletion(t, 5*time.Second)
}
