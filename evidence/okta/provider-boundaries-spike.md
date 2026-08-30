# Okta provider-boundary spike

- Date: 2026-08-30
- Result: resolved by ADR-093

Official provider release `v7.0.0` was published 2026-08-24. Its lightweight
tag resolves to verified commit `1f0d81dbcda7af4de754f73efc280ada9e3059d8`
and tree `99f2e3a4c5cdf8fb70e308193e8b41d1ca3bd9c2`. Terraform `1.12.2`
verified partner signature key `954A8621ECA044EC` and protocol `5.11` without
provider configuration or credentials.

The exact schema contains 162 resources and 109 data sources. Stable
architecture owners are org, realm, application, authorization-server,
external-IdP, custom-domain, hook, log-stream, security-event-provider, and
network-zone constructs. Most remaining surface configures those owners or
administers identities and access.

Policy and routing helpers can reference both applications and providers, but
Rootform Language facts originate from the helper representation. They remain
supporting details; deriving an application-to-provider authentication flow
would exceed evidence. Okta/Auth0 terminology overlaps, while tenant,
connection, and authorization-server ownership differs enough to defer core
promotion until Auth0 is verified.

Okta press assets require separate terms of use. The dialect therefore uses
generic local identities and no remote or vendored trademark asset.
