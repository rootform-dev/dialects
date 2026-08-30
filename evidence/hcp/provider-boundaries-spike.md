# HCP provider-boundaries spike

- Result: Resolved
- Date: 2026-08-30
- Provider: `hashicorp/hcp` `0.114.0`
- Decision: ADR-088

## Verdict

Provider 0.114.0 proves broad HCP architecture across 104 constructs without
credentials or live HCP access. It exposes current platform, networking, Vault
Dedicated, Boundary, Packer, Waypoint, Vault Secrets, and Vault Radar surfaces.
It also retains HCP Consul Dedicated resources after official end of life; they
must remain explicit legacy architecture, not current-product claims.

## Reproducible observation

- Terraform `1.12.2`, isolated direct provider installation; signed by HashiCorp key `34365D9472D7468F`.
- Schema: 67 resources, 37 data sources; 235152 bytes; SHA-256 `7002be2492885d4c4227b46b8afa0371178b514d16cbc020a263c1e6fed8c193`.
- Provider archive SHA-256: `fbcd00c4c2eff9d8b36da611e9fa71e4bdccc69e12ca52d78edc0bbfce65315c`.
- Source archive SHA-256: `7d230e20b00aaa80f13e564171ab9a4e3d986d7ddab176e09b4972f05dbbb66c`.
- Release commit `47cda4099f52c661531ed1ebb0166461ba87d58e`, tree `fc8982db2046e2410489a36fed86febe8ab8cbf3`, verified signature.
- HCP Consul Dedicated reached end of life on `2025-11-12`.

## Official sources

- https://github.com/hashicorp/terraform-provider-hcp/releases/tag/v0.114.0
- https://registry.terraform.io/providers/hashicorp/hcp/0.114.0/docs
- https://developer.hashicorp.com/hcp/docs
- https://developer.hashicorp.com/hcp/docs/hcp/network
- https://developer.hashicorp.com/hcp/docs/changelog
- https://developer.hashicorp.com/consul/docs/hcp
