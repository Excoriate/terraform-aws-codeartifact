# AWS CodeArtifact Terraform Module Composition and Interfaces

## 1. Module Composition Diagram

```mermaid
graph TD
    subgraph "Foundation Layer [MVP]"
        F[terraform-aws-codeartifact-foundation]
        KMS[KMS Module]
        S3[S3 Module]
        IAM_Base[Base IAM Module]
        F --> KMS
        F --> S3
        F --> IAM_Base
    end

    subgraph "Domain Layer [MVP]"
        D[terraform-aws-codeartifact-domain]
        Domain[Domain Module]
        DomainPolicy[Domain Permissions Module] // Renamed for clarity
        D --> Domain
        D --> DomainPolicy
    end

    subgraph "Repositories Layer [MVP]"
        R[terraform-aws-codeartifact-repositories]
        HostedRepo[Hosted Repos Module]
        ProxyRepo[Proxy Repos Module]
        GroupRepo[Group Repos Module]
        RepoCreate[Repository Creation Module(s)] // Abstracting the creation part
        R --> RepoCreate
        // R --> HostedRepo (Implied within RepoCreate)
        // R --> ProxyRepo (Implied within RepoCreate)
        // R --> GroupRepo (Implied within RepoCreate)
    end

    subgraph "External Connections Layer [MVP]"
        E[terraform-aws-codeartifact-connections]
        ExtConn[External Connections Module]
        ConnPolicy[Connection Policy Module]
        E --> ExtConn
        E --> ConnPolicy
    end

    subgraph "Security Layer [MVP Core]"
        S[terraform-aws-codeartifact-security]
        IAM_Roles[IAM Roles Module]
        RepoPolicy[Repository Permissions Module] // Added specific module
        TokenGen[Token Generator Module]
        CrossAcc[Cross Account Module]
        S --> IAM_Roles
        S --> RepoPolicy // Added link
        S --> TokenGen
        S --> CrossAcc
    end

    subgraph "CI/CD Layer [MVP Core]"
        C[terraform-aws-codeartifact-cicd]
        TokenMgmt[Token Management Module]
        PipelineInt[Pipeline Integration Module]
        BuildInt[Build Integration Module]
        C --> TokenMgmt
        C --> PipelineInt
        C --> BuildInt
    end

    subgraph "Monitoring Layer [MVP Basic]"
        M[terraform-aws-codeartifact-monitoring]
        CW_Dash[CloudWatch Dashboards Module]
        CW_Alerts[CloudWatch Alerts Module]
        CT_Logs[CloudTrail Logs Module]
        M --> CW_Dash
        M --> CW_Alerts
        M --> CT_Logs
    end

    %% Foundation to Domain Layer
    F --> |"Outputs: kms_key_arn, base_role_arn"| D

    %% Domain to Repositories Layer
    D --> |"Outputs: domain_arn, domain_name"| R

    %% Repositories to External Connections Layer
    R --> |"Outputs: repository_names, repository_endpoints"| E

    %% Domain & Repositories to Security Layer
    D --> |"Outputs: domain_arn, domain_name"| S // Domain name might be needed for policy
    R --> |"Outputs: repository_arns, repository_names"| S // Repo names/arns needed for policy

    %% Security to CI/CD Layer
    S --> |"Outputs: role_arns, token_generator_lambda"| C

    %% Multiple to Monitoring Layer
    F --> |"Outputs: log_group_arn"| M
    D --> |"Outputs: domain_name"| M
    R --> |"Outputs: repository_names"| M
    S --> |"Outputs: role_arns"| M

    classDef mvp fill:#d0f0c0,stroke:#333;
    classDef mvpCore fill:#e8f0c0,stroke:#333;
    classDef mvpBasic fill:#f0e0c0,stroke:#333;

    class F,D,R,E mvp;
    class S,C mvpCore;
    class M mvpBasic;
```

## 2. Module Interface Specifications

### Foundation Module (`terraform-aws-codeartifact-foundation`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `aws_region`: Region for deployment<br>• `environment`: Environment name<br>• `resource_prefix`: Resource naming prefix<br>• `tags`: Standard resource tags |
| **Optional Inputs** | • `kms_deletion_window`: KMS key deletion window<br>• `s3_bucket_force_destroy`: Allow bucket force destroy<br>• `log_retention_days`: CloudWatch log retention |
| **Outputs** | • `kms_key_arn`: KMS key ARN for encryption<br>• `s3_bucket_arn`: Backup bucket ARN<br>• `base_role_arn`: Base IAM role ARN<br>• `log_group_arn`: CloudWatch log group ARN |
| **Main Resources** | • AWS KMS key for encryption<br>• S3 bucket for backups/migration<br>• Base IAM roles and policies<br>• CloudWatch log groups |
| **Dependencies** | None - This is the foundation module |

### Domain Module (`terraform-aws-codeartifact-domain`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `domain_name`: CodeArtifact domain name<br>• `kms_key_arn`: KMS key ARN from foundation<br>• `tags`: Resource tags |
| **Optional Inputs** | • `domain_owner`: AWS account ID of domain owner<br>• `encryption_mode`: Type of encryption (default: KMS) |
| **Outputs** | • `domain_arn`: Domain ARN<br>• `domain_name`: Domain name<br>• `domain_owner`: Domain owner account ID<br>• `domain_endpoint`: Domain endpoint |
| **Main Resources** | • AWS CodeArtifact domain<br>• Domain encryption settings |
| **Dependencies** | • Foundation module (KMS key) |

### Repositories Module (`terraform-aws-codeartifact-repositories`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `domain_name`: Domain name from domain module<br>• `repository_configs`: Map of repository configurations<br>• `tags`: Resource tags |
| **Optional Inputs** | • `default_upstreams`: Default upstream repos<br>• `repository_retention`: Retention period settings |
| **Outputs** | • `repository_arns`: Map of repository ARNs<br>• `repository_endpoints`: Map of repository endpoints<br>• `repository_names`: List or Map of repository names |
| **Main Resources** | • Hosted repositories<br>• Proxy repositories<br>• Group repositories |
| **Dependencies** | • Domain module (domain name and ARN) |

### External Connections Module (`terraform-aws-codeartifact-connections`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `repository_names`: Repository names from repo module<br>• `external_connection_configs`: External connection settings |
| **Optional Inputs** | • `connection_policies`: Custom connection policies<br>• `rate_limits`: Connection rate limits |
| **Outputs** | • `connection_arns`: External connection ARNs<br>• `connection_status`: Connection health status |
| **Main Resources** | • External connections to public repos<br>• Connection policies<br>• Rate limiting configurations |
| **Dependencies** | • Repositories module (repository names) |

### Security Module (`terraform-aws-codeartifact-security`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `domain_arn`: Domain ARN from domain module<br>• `repository_arns`: Repository ARNs from repo module<br>• `permission_sets`: IAM permission configurations |
| **Optional Inputs** | • `token_ttl`: Authentication token TTL<br>• `cross_account_access`: Cross-account access settings |
| **Outputs** | • `role_arns`: Map of created IAM role ARNs<br>• `policy_arns`: Map of created policy ARNs<br>• `token_generator_lambda`: Token generator Lambda ARN |
| **Main Resources** | • IAM roles and policies<br>• Repository permissions policies (via dedicated module)<br>• Token generation Lambda<br>• Cross-account access roles |
| **Dependencies** | • Domain module (domain ARN, domain name)<br>• Repositories module (repository ARNs, repository names) |

### Repository Permissions Module (`terraform-aws-codeartifact-repository-permissions`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `domain_name`: Domain name from domain module<br>• `repository_name`: Name of the target repository (or map/list)<br>• `policy_document`: JSON policy document string (or map/list) |
| **Optional Inputs** | • `domain_owner`: AWS account ID of domain owner<br>• `tags`: Resource tags |
| **Outputs** | • `policy_revision`: Revision ID of the applied policy (or map/list) |
| **Main Resources** | • `aws_codeartifact_repository_permissions_policy` |
| **Dependencies** | • Domain module (domain name, owner)<br>• Repositories module (repository name/ARN) |

### CI/CD Integration Module (`terraform-aws-codeartifact-cicd`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `security_role_arns`: IAM role ARNs from security module<br>• `repository_endpoints`: Repository endpoints from repo module |
| **Optional Inputs** | • `pipeline_configs`: CI/CD pipeline configurations<br>• `build_tool_configs`: Build tool settings |
| **Outputs** | • `token_management_api`: Token management API endpoint<br>• `pipeline_configs`: Generated pipeline configurations |
| **Main Resources** | • Token management Lambda<br>• Pipeline integration configs<br>• Build tool helpers |
| **Dependencies** | • Security module (IAM roles)<br>• Repositories module (endpoints) |

### Monitoring Module (`terraform-aws-codeartifact-monitoring`)

| Component | Details |
|-----------|---------|
| **Required Inputs** | • `domain_name`: Domain name from domain module<br>• `repository_names`: Repository names from repo module<br>• `alert_endpoints`: Alert notification endpoints |
| **Optional Inputs** | • `dashboard_config`: Custom dashboard settings<br>• `alert_thresholds`: Custom alert thresholds |
| **Outputs** | • `dashboard_urls`: CloudWatch dashboard URLs<br>• `alarm_arns`: CloudWatch alarm ARNs<br>• `log_group_arns`: CloudTrail log group ARNs |
| **Main Resources** | • CloudWatch dashboards<br>• CloudWatch alarms<br>• CloudTrail trails<br>• SNS topics |
| **Dependencies** | • Foundation module (logging)<br>• Domain module (domain name)<br>• Repositories module (repository names) |
