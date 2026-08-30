# Grafana provider boundary spike

- Status: Resolved
- Date: 2026-08-30
- Decision: ADR-091

Signed `grafana/grafana` `4.45.2` schema contains 121 resources, 50 data
sources, and function `k6bundle`. Official product and provider documentation
prove durable roots for Grafana Cloud stacks, data sources/PDC, Cloud Provider
Observability, Fleet Management, Frontend Observability, Synthetic Monitoring,
k6, Knowledge Graph, OnCall, Git Sync, Secrets Management, and Assistant MCP.

Rootform can prove ownership and cross-dialect authorization only through exact
references such as `stack_id`, `org_id`, `role_arn`, `client_id`, PDC network
IDs, and bounded Git Sync/keeper paths. Provider config, URLs, types, JSON,
scripts, manifests, and dependencies are insufficient. This supports broad
representation without dashboard/alert/IAM inventory and without secret reads.

Telemetry abstractions remain Grafana-local until New Relic completes the
Datadog/Grafana/New Relic comparison. PDC is not promoted to `core.private-endpoint`:
official docs define an agent-backed outbound SSH connectivity network, not a
provider-neutral private endpoint.
