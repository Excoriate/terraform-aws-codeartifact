package integration

import (
	"context"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/codeartifact"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestBasicExampleDeployment validates that the basic example can be deployed
// to AWS and creates the expected resources.
func TestBasicExampleDeployment(t *testing.T) {
	t.Parallel()

	// Skip if running in short mode
	if testing.Short() {
		t.Skip("Skipping integration test in short mode")
	}

	// Setup AWS clients
	_, _, codeartifactClient := setupAWSClients(t)

	// Generate a unique domain name for the test
	domainName := generateUniqueResourceName("test-domain")

	// Configure Terraform options
	terraformOptions := setupTerraformOptions(t, "foundation/basic", map[string]interface{}{
		"is_enabled":           true,
		"domain_name":          domainName,
		"force_destroy_domain": true,
		"domain_description":   "Test domain for integration tests",
		"domain_tags": map[string]string{
			"Environment": "test",
			"ManagedBy":   "terratest",
		},
	})

	// Clean up resources when the test completes
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Get domain name from Terraform output
	outputDomainName := terraform.Output(t, terraformOptions, "domain_name")
	require.Equal(t, domainName, outputDomainName, "Domain name output should match input")

	// Validate domain exists in AWS
	describeOutput, err := codeartifactClient.DescribeDomain(context.TODO(), &codeartifact.DescribeDomainInput{
		Domain: &domainName,
	})
	require.NoError(t, err, "Failed to describe CodeArtifact domain")
	require.NotNil(t, describeOutput.Domain, "Domain should exist")
	require.Equal(t, domainName, *describeOutput.Domain.Name, "Domain name should match")

	// Wait for resource deletion to propagate
	defer waitForResourceDeletion(t, 5*time.Second)
}

// TestCompleteExampleDeployment validates that the complete example can be deployed
// to AWS and creates the expected resources with all features enabled.
func TestCompleteExampleDeployment(t *testing.T) {
	t.Parallel()

	// Skip if running in short mode
	if testing.Short() {
		t.Skip("Skipping integration test in short mode")
	}

	// Setup AWS clients
	_, _, codeartifactClient := setupAWSClients(t)

	// Generate unique resource names for the test
	domainName := generateUniqueResourceName("test-domain")
	repoName := generateUniqueResourceName("test-repo")

	// Configure Terraform options
	terraformOptions := setupTerraformOptions(t, "foundation/complete", map[string]interface{}{
		"is_enabled":             true,
		"domain_name":            domainName,
		"force_destroy_domain":   true,
		"domain_description":     "Complete test domain for integration tests",
		"is_repository_enabled":  true,
		"repository_name":        repoName,
		"repository_description": "Test repository for integration tests",
		"domain_tags": map[string]string{
			"Environment": "test",
			"ManagedBy":   "terratest",
		},
	})

	// Clean up resources when the test completes
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform configuration
	terraform.InitAndApply(t, terraformOptions)

	// Get domain and repository names from Terraform output
	outputDomainName := terraform.Output(t, terraformOptions, "domain_name")
	outputRepoName := terraform.Output(t, terraformOptions, "repository_name")

	require.Equal(t, domainName, outputDomainName, "Domain name output should match input")
	require.Equal(t, repoName, outputRepoName, "Repository name output should match input")

	// Validate domain exists in AWS
	describeOutput, err := codeartifactClient.DescribeDomain(context.TODO(), &codeartifact.DescribeDomainInput{
		Domain: &domainName,
	})
	require.NoError(t, err, "Failed to describe CodeArtifact domain")
	require.NotNil(t, describeOutput.Domain, "Domain should exist")
	require.Equal(t, domainName, *describeOutput.Domain.Name, "Domain name should match")

	// Validate repository exists in AWS
	describeRepoOutput, err := codeartifactClient.DescribeRepository(context.TODO(), &codeartifact.DescribeRepositoryInput{
		Domain:     &domainName,
		Repository: &repoName,
	})
	require.NoError(t, err, "Failed to describe CodeArtifact repository")
	require.NotNil(t, describeRepoOutput.Repository, "Repository should exist")
	require.Equal(t, repoName, *describeRepoOutput.Repository.Name, "Repository name should match")

	// Wait for resource deletion to propagate
	defer waitForResourceDeletion(t, 5*time.Second)
}
