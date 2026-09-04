# Auth0 provider-boundary spike

- Date: 2026-08-30
- Result: Resolved

Official provider `v1.56.0` was published 2026-08-27. Its lightweight tag
resolves to verified commit `573bb7646fdcd2b4bb19064c36ae5622dfe0e876`
and tree `97c89ec56919149985aa367184b05bfdedded472`. Terraform `1.12.2`
verified provider signature key `412BCE2947E6D1B4` and protocol `5` without
provider configuration or credentials. Exact schema contains 78 resources and
51 data sources.

Stable architecture owners are tenant, Organization, Application, API,
Connection, Directory Sync, domain, extension, workflow, stream, Network ACL,
and notification-provider constructs. Association and security helpers remain
details; users, roles, presentation configuration, credentials, code, JSON,
and aggregates have no independent topology.

Vault OIDC clients, Okta app integrations, and Auth0 clients share one minimal
registered relying-party role, so `core.identity-application` is stable.
Tenant, Connection, authorization-server, and extension execution semantics do
not share one honest ownership contract and remain local.

Provider source references remote Auth0 logo files but does not establish
redistribution rights for those assets. Dialect uses generic local identities.
