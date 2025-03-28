Get information about the TLS certificates securing a host.

Use this data source to get information, such as SHA1 fingerprint or serial number, about the TLS certificates that protects a URL.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#example-usage)

### [URL Usage](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#url-usage)

```terraform
resource "aws_eks_cluster" "example" { name = "example" } data "tls_certificate" "example" { url = aws_eks_cluster.example.identity[0].oidc[0].issuer } resource "aws_iam_openid_connect_provider" "example" { client_id_list = ["sts.amazonaws.com"] thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint] url = aws_eks_cluster.example.identity[0].oidc[0].issuer }
```

### [Content Usage](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#content-usage)

```terraform
data "tls_certificate" "example_content" { content = file("example.pem") }
```

## [Schema](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#schema)

### [Optional](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#optional)

-   [`url`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#url-1) (String) The URL of the website to get the certificates from. Cannot be used with `content`.
-   [`content`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#content-1) (String) The content of the certificate in [PEM (RFC 1421)](https://datatracker.ietf.org/doc/html/rfc1421) format. Cannot be used with `url`.
-   [`verify_chain`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#verify_chain-1) (Boolean) Whether to verify the certificate chain while parsing it or not (default: `true`). Cannot be used with `content`.

### [Read-Only](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#read-only)

-   [`id`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#id-1) (String) Unique identifier of this data source: hashing of the certificates in the chain.
-   [`certificates`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#certificates-1) (List of Object) The certificates protecting the site, with the root of the chain first. (see [below for nested schema](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#nestedatt--certificates))

### [Nested Schema for `certificates`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#nested-schema-for-certificates)

Read-Only:

-   [`is_ca`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#is_ca-1) (Boolean) `true` if the certificate is of a CA (Certificate Authority).
-   [`issuer`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#issuer-1) (String) Who verified and signed the certificate, roughly following [RFC2253](https://tools.ietf.org/html/rfc2253).
-   [`not_after`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#not_after-1) (String) The time until which the certificate is invalid, as an [RFC3339](https://tools.ietf.org/html/rfc3339) timestamp.
-   [`not_before`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#not_before-1) (String) The time after which the certificate is valid, as an [RFC3339](https://tools.ietf.org/html/rfc3339) timestamp.
-   [`public_key_algorithm`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#public_key_algorithm-1) (String) The key algorithm used to create the certificate.
-   [`serial_number`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#serial_number-1) (String) Number that uniquely identifies the certificate with the CA's system. The `format` function can be used to convert this _base 10_ number into other bases, such as hex.
-   [`sha1_fingerprint`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#sha1_fingerprint-1) (String) The SHA1 fingerprint of the public key of the certificate.
-   [`signature_algorithm`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#signature_algorithm-1) (String) The algorithm used to sign the certificate.
-   [`subject`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#subject-1) (String) The entity the certificate belongs to, roughly following [RFC2253](https://tools.ietf.org/html/rfc2253).
-   [`version`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#version-1) (Number) The version the certificate is in.
-   [`cert_pem`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate#cert_pem-1) (String) Certificate data in [PEM (RFC 1421)](https://datatracker.ietf.org/doc/html/rfc1421) format. **NOTE**: the [underlying](https://pkg.go.dev/encoding/pem#Encode) [libraries](https://pkg.go.dev/golang.org/x/crypto/ssh#MarshalAuthorizedKey) that generate this value append a `\n` at the end of the PEM. In case this disrupts your use case, we recommend using [`trimspace()`](https://www.terraform.io/language/functions/trimspace).
