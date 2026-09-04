# Consul provider boundary spike

- Date: 2026-08-30
- Provider: `hashicorp/consul` `2.23.0`
- Result: Resolved

Terraform 1.12.2 installed the provider directly and reported a HashiCorp
signature. Schema RPC returned 33 resources and 24 data sources. The provider
targets an existing Consul endpoint; provider address/datacenter/token cannot
prove or create a cluster. Plural data sources cannot become synthetic nodes.

`consul_config_entry` exposes `kind`, `name`, and opaque `config_json`.
Rootform can safely predicate documented kinds, but cannot interpret nested
JSON semantics or references without conflating unrelated values. Structured
resources expose exact top-level paths. Current Rootform Language cannot
iterate repeated nested blocks, so nested intention, resolver, router, and
splitter references remain unclaimed; their owner service `name` is retained.
Exported-service lists remain usable because they are top-level collections.

Current Consul docs mark ingress gateway deprecated and API gateway preferred.
Provider docs mark `consul_agent_service` and `consul_catalog_entry` deprecated,
and `consul_intention` legacy for Consul 1.8 and earlier. Current cluster
peering docs require Consul 1.14+, so stale provider preview copy is not used as
current lifecycle terminology.

Core comparison keeps Consul cluster peering separate from virtual-network
peering, keeps service mesh local because AWS/Azure root parity is not yet
represented, and reuses only `core/api-gateway` plus core contexts. JWT/identity
provider promotion waits for Okta/Auth0.

Official sources: Terraform Registry exact provider docs, provider GitHub
release/source, Consul configuration entries, gateways, service intentions,
cluster peering, service mesh, and multi-tenancy documentation.
