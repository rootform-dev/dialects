# Datadog provider boundary spike

- Date: 2026-08-30
- Result: resolved by ADR-090

Provider `4.19.0` exposes 152 resources and 82 data sources. Terraform 1.12.2
installed signed protocol-6 provider without configuration or credentials.
Schema snapshot is 8,316,623 bytes with SHA-256
`11a37efaaffb26ee8ebc890ab2092a516005d0b8a659b158fd9954dc51b44f6c`.

Official product and provider docs establish:

- Observability Pipelines collect/process telemetry inside customer infrastructure and route it through nested sources, processors, and destinations.
- AWS, Azure, and Google Cloud resources configure data-collection integrations; they do not prove application flows.
- private Synthetic locations execute tests inside private networks; a test remains monitoring configuration, not the monitored endpoint.
- child organizations isolate data; organization connections explicitly share selected metrics/logs visibility.
- monitor/dashboard/alert objects configure operations and own no independent runtime topology.

Current Rootform Language cannot iterate nested repeated blocks. Pipeline source
and destination kinds therefore remain unclaimed; fixed-index interpretation
would be dishonest. Opaque app/workflow/catalog/API payloads and all credential
paths remain unread. Durable roots become entities/scopes; useful configuration
becomes details; remaining helpers/configuration are intentionally unrepresented.
