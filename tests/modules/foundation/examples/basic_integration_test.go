//go:build integration && examples

package examples

import (
	"context"
	"testing"
	"time"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/helper"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestDeploymentOnExamplesBasicWhenDefaultFixture verifies the full deployment of
// the basic example with the default fixture (all components enabled).
func TestDeploymentOnExamplesBasicWhenDefaultFixture(t *testing.T) {
	t.Parallel()

	// Use helper function to setup terraform options with isolated provider cache
	terraformOptions := helper.SetupTerraformOptions(t, "foundation/basic", nil)

	// Add var files to the options
	terraformOptions.VarFiles = []string{"fixtures/default.tfvars"}

	// Cleanup resources when the test completes
	defer func() {
		terraform.Destroy(t, terraformOptions)
		helper.WaitForResourceDeletion(t, 30*time.Second)
	}()

	t.Logf("🔍 Terraform Example Directory: %s", terraformOptions.TerraformDir)
	t.Logf("📝 Using fixture: fixtures/default.tfvars")

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs from Terraform
	kmsKeyId := terraform.Output(t, terraformOptions, "kms_key_id")
	kmsKeyArn := terraform.Output(t, terraformOptions, "kms_key_arn")
	kmsKeyAliasName := terraform.Output(t, terraformOptions, "kms_key_alias_name")
	s3BucketId := terraform.Output(t, terraformOptions, "s3_bucket_id")
	logGroupName := terraform.Output(t, terraformOptions, "log_group_name")

	// Setup AWS SDK v2 configuration with explicit region
	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("us-west-2"))
	require.NoError(t, err, "Failed to load AWS configuration")

	// Verify KMS Key
	t.Run("Verify KMS Key", func(t *testing.T) {
		kmsClient := kms.NewFromConfig(cfg)

		// Verify KMS Key exists
		describeKeyOutput, err := kmsClient.DescribeKey(ctx, &kms.DescribeKeyInput{
			KeyId: aws.String(kmsKeyId),
		})
		require.NoError(t, err, "Failed to describe KMS key")

		assert.Equal(t, kmsKeyArn, *describeKeyOutput.KeyMetadata.Arn, "KMS Key ARN mismatch")
		assert.Equal(t, "Enabled", string(describeKeyOutput.KeyMetadata.KeyState), "KMS Key should be enabled")

		// Verify KMS Key Alias
		listAliasesOutput, err := kmsClient.ListAliases(ctx, &kms.ListAliasesInput{
			KeyId: aws.String(kmsKeyId),
		})
		require.NoError(t, err, "Failed to list KMS key aliases")

		aliasFound := false
		for _, alias := range listAliasesOutput.Aliases {
			if *alias.AliasName == kmsKeyAliasName {
				aliasFound = true
				break
			}
		}
		assert.True(t, aliasFound, "KMS Key Alias not found")
	})

	// Verify S3 Bucket
	t.Run("Verify S3 Bucket", func(t *testing.T) {
		s3Client := s3.NewFromConfig(cfg)

		// Verify S3 Bucket exists
		_, err := s3Client.HeadBucket(ctx, &s3.HeadBucketInput{
			Bucket: aws.String(s3BucketId),
		})
		require.NoError(t, err, "Failed to head S3 bucket")

		// Get bucket encryption
		getBucketEncryptionOutput, err := s3Client.GetBucketEncryption(ctx, &s3.GetBucketEncryptionInput{
			Bucket: aws.String(s3BucketId),
		})
		require.NoError(t, err, "Failed to get S3 bucket encryption")

		// Verify SSE-KMS is enabled
		encryptionRules := getBucketEncryptionOutput.ServerSideEncryptionConfiguration.Rules
		assert.GreaterOrEqual(t, len(encryptionRules), 1, "Bucket should have at least one encryption rule")

		// At least one rule should use SSE-KMS
		kmsEncryptionFound := false
		for _, rule := range encryptionRules {
			if rule.ApplyServerSideEncryptionByDefault != nil &&
				rule.ApplyServerSideEncryptionByDefault.SSEAlgorithm == "aws:kms" {
				kmsEncryptionFound = true
				break
			}
		}
		assert.True(t, kmsEncryptionFound, "S3 Bucket should use SSE-KMS encryption")
	})

	// Verify CloudWatch Log Group
	t.Run("Verify CloudWatch Log Group", func(t *testing.T) {
		cwlClient := cloudwatchlogs.NewFromConfig(cfg)

		// Verify Log Group exists
		describeLogGroupsOutput, err := cwlClient.DescribeLogGroups(ctx, &cloudwatchlogs.DescribeLogGroupsInput{
			LogGroupNamePrefix: aws.String(logGroupName),
		})
		require.NoError(t, err, "Failed to describe CloudWatch log groups")

		logGroupFound := false
		var retentionDays int32
		for _, group := range describeLogGroupsOutput.LogGroups {
			if *group.LogGroupName == logGroupName {
				logGroupFound = true
				retentionDays = *group.RetentionInDays
				break
			}
		}
		assert.True(t, logGroupFound, "CloudWatch Log Group not found")
		assert.Equal(t, int32(30), retentionDays, "CloudWatch Log Group retention days should be 30")
	})
}
