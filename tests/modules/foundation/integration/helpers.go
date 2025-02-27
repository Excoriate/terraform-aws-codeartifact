//go:build integration

package test

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/codeartifact"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/stretchr/testify/require"
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
