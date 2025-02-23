Here are some concepts and terms to know when you use CodeArtifact.

###### Topics

-   [Asset](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-asset)
-   [Domain](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-domain)
-   [Repository](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-repository)
-   [Package](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package)
-   [Package group](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-group)
-   [Package namespace](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-namespace)
-   [Package version](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-version)
-   [Package version revision](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-version-revision)
-   [Upstream repository](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-upstream)

## Asset

An _asset_ is an individual file stored in CodeArtifact that's associated with a package version, such as an npm `.tgz` file or Maven POM and JAR files.

## Domain

Repositories are aggregated into a higher-level entity known as a _domain_. All package assets and metadata are stored in the domain, but they are consumed through repositories. A given package asset, such as a Maven JAR file, is stored once per domain, no matter how many repositories it's present in. All of the assets and metadata in a domain are encrypted with the same AWS KMS key (KMS key) stored in AWS Key Management Service (AWS KMS).

Each repository is a member of a single domain and can't be moved to a different domain.

Using a domain, you can apply an organizational policy across multiple repositories. With this approach, you determine which accounts can access repositories in the domain, and which public repositories can be used as the sources of packages.

Although an organization can have multiple domains, we recommend a single production domain that contains all published artifacts. That way, teams can find and share packages across your organization.

## Repository

A CodeArtifact _repository_ contains a set of [package versions](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-version), each of which maps to a set of [assets](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-asset). Repositories are polyglot—a single repository can contain packages of any supported type. Each repository exposes endpoints for fetching and publishing packages using tools like the nuget CLI, the npm CLI, the Maven CLI (mvn), and pip. You can create up to 1,000 repositories per domain.

## Package

A _package_ is a bundle of software and the metadata that is required to resolve dependencies and install the software. In CodeArtifact, a package consists of a package name, an optional [namespace](https://docs.aws.amazon.com/codeartifact/latest/ug/codeartifact-concepts.html#welcome-concepts-package-namespace) such as `@types` in `@types/node`, a set of package versions, and package-level metadata such as npm tags.

AWS CodeArtifact supports [Cargo](https://docs.aws.amazon.com/codeartifact/latest/ug/using-cargo.html), [generic](https://docs.aws.amazon.com/codeartifact/latest/ug/using-generic.html), [Maven](https://docs.aws.amazon.com/codeartifact/latest/ug/using-maven.html), [npm](https://docs.aws.amazon.com/codeartifact/latest/ug/using-npm.html), [NuGet](https://docs.aws.amazon.com/codeartifact/latest/ug/using-nuget.html), [PyPI](https://docs.aws.amazon.com/codeartifact/latest/ug/using-python.html), [Ruby](https://docs.aws.amazon.com/codeartifact/latest/ug/using-ruby.html), [Swift](https://docs.aws.amazon.com/codeartifact/latest/ug/using-swift.html) package formats.

## Package group

_Package groups_ can be used to apply configuration to multiple packages that match a defined pattern using package format, package namespace, and package name. You can use package groups to more conveniently configure package origin controls for multiple packages. Package origin controls are used to block or allow ingestion or publishing of new package versions, which protects users from malicious actions known as dependency substitution attacks.

## Package namespace

Some package formats support hierarchical package names to organize packages into logical groups and help avoid name collisions. For example, npm supports scopes. For more information, see the [npm scopes documentation](https://docs.npmjs.com/cli/v7/using-npm/scope). The npm package `@types/node` has a scope of `@types` and a name of `node`. There are many other package names in the `@types` scope. In CodeArtifact, the scope (“types”) is referred to as the package namespace and the name (“node”) is referred to as the package name. For Maven packages, the package namespace corresponds to the Maven groupID. The Maven package `org.apache.logging.log4j:log4j` has a groupID (package namespace) of `org.apache.logging.log4j` and the artifactID (package name) `log4j`. For generic packages, a [namespace](https://docs.aws.amazon.com/codeartifact/latest/APIReference/API_PublishPackageVersion.html#namespace) is required. Some package formats such as PyPI don't support hierarchical names with a concept similar to npm scope or Maven groupID. Without a way to group package names, it can be more difficult to avoid name collisions.

## Package version

A _package version_ identifies the specific version of a package, such as `@types/node 12.6.9`. The version number format and semantics vary for different package formats. For example, npm package versions must conform to the [Semantic Versioning specification](https://semver.org/). In CodeArtifact, a package version consists of the version identifier, package version level metadata, and a set of assets.

## Package version revision

A _package version revision_ is a string that identifies a specific set of assets and metadata for a package version. Each time a package version is updated, a new package version revision is created. For example, you might publish a source distribution archive (**sdist**) for a Python package version, and later add a Python **wheel** that contains compiled code to the same version. When you publish the **wheel**, a new package version revision is created.

## Upstream repository

One repository is _upstream_ of another when the package versions in it can be accessed from the repository endpoint of the downstream repository. This approach effectively merges the contents of the two repositories from the point of view of a client. Using CodeArtifact, you can create an upstream relationship between two repositories.