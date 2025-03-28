Provides an IAM OpenID Connect provider.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#example-usage)

### [Basic Usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#basic-usage)

```terraform
resource "aws_iam_openid_connect_provider" "default" { url = "https://accounts.google.com" client_id_list = [ "266362248691-342342xasdasdasda-apps.googleusercontent.com", ] thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"] }
```

### [Without A Thumbprint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#without-a-thumbprint)

```terraform
resource "aws_iam_openid_connect_provider" "default" { url = "https://accounts.google.com" client_id_list = [ "266362248691-342342xasdasdasda-apps.googleusercontent.com", ] }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#argument-reference)

This resource supports the following arguments:

-   [`url`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#url-1) - (Required) URL of the identity provider, corresponding to the `iss` claim.
-   [`client_id_list`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#client_id_list-1) - (Required) List of client IDs (audiences) that identify the application registered with the OpenID Connect provider. This is the value sent as the `client_id` parameter in OAuth requests.
-   [`thumbprint_list`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#thumbprint_list-1) - (Optional) List of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). For certain OIDC identity providers (e.g., Auth0, GitHub, GitLab, Google, or those using an Amazon S3-hosted JWKS endpoint), AWS relies on its own library of trusted root certificate authorities (CAs) for validation instead of using any configured thumbprints. In these cases, any configured `thumbprint_list` is retained in the configuration but not used for verification. For other IdPs, if no `thumbprint_list` is provided, IAM automatically retrieves and uses the top intermediate CA thumbprint from the OIDC IdP server certificate. However, if a `thumbprint_list` is initially configured and later removed, Terraform does not prompt IAM to retrieve a thumbprint the same way. Instead, it continues using the original thumbprint list from the initial configuration. This differs from the behavior when creating an `aws_iam_openid_connect_provider` without a `thumbprint_list`.
-   [`tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#tags-1) - (Optional) Map of resource tags for the IAM OIDC provider. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level.

## [Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#attribute-reference)

This resource exports the following attributes in addition to the arguments above:

-   [`arn`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#arn-1) - ARN assigned by AWS for this provider.
-   [`tags_all`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#tags_all-1) - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## [Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#import)

In Terraform v1.5.0 and later, use an [`import` block](https://developer.hashicorp.com/terraform/language/import) to import IAM OpenID Connect Providers using the `arn`. For example:

```terraform
import { to = aws_iam_openid_connect_provider.default id = "arn:aws:iam::123456789012:oidc-provider/accounts.google.com" }
```

Using `terraform import`, import IAM OpenID Connect Providers using the `arn`. For example:

```console
% terraform import aws_iam_openid_connect_provider.default arn:aws:iam::123456789012:oidc-provider/accounts.google.com
```
