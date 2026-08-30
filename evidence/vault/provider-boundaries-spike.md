# Vault provider-boundaries spike

- Result: Resolved
- Date: 2026-08-30
- Provider: `hashicorp/vault` `5.11.0`
- Decision: ADR-087

## Question and verdict

Can provider 5.11.0 prove broad Vault architecture without treating provider
configuration as a cluster or inspecting sensitive values? Yes. Its 278
construct schemas expose durable namespaces, engines, auth, identity, PKI,
key-management, sync, audit, and continuity resources plus explicit reference
paths. No resource creates the Vault service itself. Sensitive, lookup, login,
credential, crypto-operation, certificate-operation, and arbitrary-endpoint
surfaces remain outside topology.

## Reproducible observation

- Terraform `1.12.2`, isolated direct provider installation.
- Provider install reported `signed by HashiCorp`; Registry signing key `34365D9472D7468F`.
- Schema: 204 resources, 50 data sources, 24 ephemeral resources.
- Schema SHA-256: `f06f3e06dd848f4ac507d2fcc3904fc59ea4c74c610faa1d3f3c1cd6cf7ba188`.
- Provider archive SHA-256: `1b62b55f7dffcefb456519ed844c6e7ec7caa0757f8fe1531d9afd59f48d2b0e`.
- Source archive SHA-256: `87080c6209a941281a46d27d9afad6673429f952883119b4dce08294f70980d7`.
- Release commit `fcb48e97776faec650b949676f2281d916e6e6d8`, tree `c8d6d9b369c16f066743571465c4866f36326456`, verified GitHub signature.

## Official sources

- https://github.com/hashicorp/terraform-provider-vault/releases/tag/v5.11.0
- https://registry.terraform.io/providers/hashicorp/vault/5.11.0/docs
- https://developer.hashicorp.com/vault/docs/secrets
- https://developer.hashicorp.com/vault/docs/auth
- https://developer.hashicorp.com/vault/docs/concepts/identity
- https://developer.hashicorp.com/vault/docs/secrets/pki
- https://developer.hashicorp.com/vault/docs/secrets/transit
- https://developer.hashicorp.com/vault/docs/enterprise/namespaces
