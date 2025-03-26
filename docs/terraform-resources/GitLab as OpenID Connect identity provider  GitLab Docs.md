-   Tier: Free, Premium, Ultimate
-   Offering: GitLab.com, GitLab Self-Managed

You can use GitLab as an [OpenID Connect](https://openid.net/developers/how-connect-works/) (OIDC) identity provider to access other services. OIDC is an identity layer that performs many of the same tasks as OpenID 2.0, but is API-friendly and usable by native and mobile applications.

Clients can use OIDC to:

-   Verify the identity of an end-user based on the authentication performed by GitLab.
-   Obtain basic profile information about the end-user in an interoperable and REST-like manner.

You can use [OmniAuth::OpenIDConnect](https://github.com/omniauth/omniauth_openid_connect) for Rails applications and there are many other available [client implementations](https://openid.net/developers/certified-openid-connect-implementations/).

GitLab uses the `doorkeeper-openid_connect` gem to provide OIDC service. For more information, see the [doorkeeper-openid\_connect repository](https://github.com/doorkeeper-gem/doorkeeper-openid_connect "Doorkeeper::OpenidConnect repository").

## Enable OIDC for OAuth applications[](https://docs.gitlab.com/integration/openid_connect_provider/#enable-oidc-for-oauth-applications "Permalink")

To enable OIDC for an OAuth application, you need to select the `openid` scope in the application settings. For more information , see [Configure GitLab as an OAuth 2.0 authentication identity provider](https://docs.gitlab.com/integration/oauth_provider/).

## Settings discovery[](https://docs.gitlab.com/integration/openid_connect_provider/#settings-discovery "Permalink")

If your client can import OIDC settings from a discovery URL, GitLab provides endpoints to access this information:

-   For GitLab.com, use `https://gitlab.com/.well-known/openid-configuration`.
-   For GitLab Self-Managed, use `https://<your-gitlab-instance>/.well-known/openid-configuration`

The following user information is shared with clients:

| Claim | Type | Description | Included in ID Token | Included in `userinfo` endpoint |
| --- | --- | --- | --- | --- |
| `sub` | `string` | The ID of the user | Yes | Yes |
| `auth_time` | `integer` | The timestamp for the user’s last authentication | Yes | No |
| `name` | `string` | The user’s full name | Yes | Yes |
| `nickname` | `string` | The user’s GitLab username | Yes | Yes |
| `preferred_username` | `string` | The user’s GitLab username | Yes | Yes |
| `email` | `string` | The user’s primary email address | Yes | Yes |
| `email_verified` | `boolean` | Whether the user’s email address is verified | Yes | Yes |
| `website` | `string` | URL for the user’s website | Yes | Yes |
| `profile` | `string` | URL for the user’s GitLab profile | Yes | Yes |
| `picture` | `string` | URL for the user’s GitLab avatar | Yes | Yes |
| `groups` | `array` | Paths for the groups the user is a member of, either directly or through an ancestor group. | No | Yes |
| `groups_direct` | `array` | Paths for the groups the user is a direct member of. | Yes | No |
| `https://gitlab.org/claims/groups/owner` | `array` | Names of the groups the user is a direct member of with the Owner role | No | Yes |
| `https://gitlab.org/claims/groups/maintainer` | `array` | Names of the groups the user is a direct member of with the Maintainer role | No | Yes |
| `https://gitlab.org/claims/groups/developer` | `array` | Names of the groups the user is a direct member of with the Developer role | No | Yes |

| Claim | Type | Description | Included in ID Token | Included in `userinfo` endpoint |
| --- | --- | --- | --- | --- |

The claims `email` and `email_verified` are included only if the application has access to the `email` scope and the user’s public email address. All other claims are available from the `/oauth/userinfo` endpoint used by OIDC clients.

### Get help

If you didn't find what you were looking for, [search the docs](https://docs.gitlab.com/search/).

If you want help with something specific and could use community support, [post on the GitLab forum](https://forum.gitlab.com/new-topic?title=topic%20title&body=topic%20body&tags=docs-feedback).

For problems setting up or using this feature (depending on your GitLab subscription).

[Request support](https://about.gitlab.com/support/)