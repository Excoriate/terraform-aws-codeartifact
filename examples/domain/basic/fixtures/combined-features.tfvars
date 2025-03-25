# Combined features fixture: demonstrates multiple domain features simultaneously
is_enabled = true
enable_domain_permissions_policy = true
# For demonstration purposes, using a placeholder account ID, uncomment to use. Consider that this error might occur
# ╷
# │ Error: creating CodeArtifact Domain Permissions Policy: operation error codeartifact: PutDomainPermissionsPolicy, https response error StatusCode: 403, RequestID: 20ec61e0-2cbc-4a57-a837-62d7e2b80c80, AccessDeniedException: User: arn:aws:iam::836411270882:root is not authorized to perform: codeartifact:PutDomainPermissionsPolicy on resource: arn:aws:codeartifact:us-west-2:123456789012:domain/example-domain because no resource-based policy allows the codeartifact:PutDomainPermissionsPolicy action
# │
# │   with module.this.aws_codeartifact_domain_permissions_policy.this[0],
# │   on ../../../modules/domain/main.tf line 13, in resource "aws_codeartifact_domain_permissions_policy" "this":
# │   13: resource "aws_codeartifact_domain_permissions_policy" "this" {
# │
# ╵
# The problem is that you're trying to create a domain in your account (XXXXXXXXXXX) but setting the domain_owner to a different account (123456789012). When the module tries to attach a permissions policy,
# it's attempting to do so on a domain owned by another account, which requires cross-account permissions that aren't set up.
# In AWS CodeArtifact, the domain_owner parameter specifies which account owns the domain. When you try to create a permissions policy for a domain owned by another account, you need explicit permissions from that account.
# domain_owner = "123456789012"
# Uses custom KMS key (default behavior)
