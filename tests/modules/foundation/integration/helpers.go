package integration

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/codeartifact"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"

	"github.com/Excoriate/terraform-aws-codeartifact/tests/pkg/repo"
)

// setupAWSClients initializes and returns AWS SDK clients for testing
func setupAWSClients(t *testing.T) (*kms.Client, *s3.Client, *codeartifact.Client) {
	// Load AWS configuration
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoError(t, err, "Failed to load AWS config")

	// Initialize clients
	kmsClient := kms.NewFromConfig(cfg)
	s3Client := s3.NewFromConfig(cfg)
	codeartifactClient := codeartifact.NewFromConfig(cfg)

	return kmsClient, s3Client, codeartifactClient
}

// generateUniqueResourceName creates a unique resource name with a prefix and timestamp
func generateUniqueResourceName(prefix string) string {
	return fmt.Sprintf("%s-%s", prefix, time.Now().Format("20060102150405"))
}

// setupTerraformOptions configures Terraform options for a test
func setupTerraformOptions(t *testing.T, examplePath string, vars map[string]interface{}) *terraform.Options {
	// Get test directory
	dirs, err := repo.NewTFSourcesDir()
	require.NoError(t, err, "Failed to get Terraform sources directory")

	// Configure Terraform options
	return &terraform.Options{
		TerraformDir: dirs.GetExamplesDir(examplePath),
		Vars:         vars,
	}
}

// waitForResourceDeletion waits for a specified duration to allow for resource deletion
// This helps with eventual consistency issues in AWS
func waitForResourceDeletion(t *testing.T, duration time.Duration) {
	t.Logf("Waiting %s for resource deletion to propagate...", duration)
	time.Sleep(duration)
}
