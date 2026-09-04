# New Relic provider boundary spike

- Date: 2026-08-30
- Result: Resolved
- Baseline: `newrelic/newrelic` `3.96.4`

## Evidence

- Registry schema: 64 resources, 19 data sources, no functions or ephemeral resources.
- Fleet Control manages homogeneous Kubernetes/host fleets, agent configurations, members, and deployments; it is not equivalent to a generic telemetry pipeline.
- Federated Logs owns an external-log storage/query setup; partitions and pipeline rules support that setup but do not become independent topology.
- Linked AWS, Azure, GCP, and OCI accounts are durable cloud-observability integrations. Service-selection resources configure those links.
- Synthetics private locations own execution infrastructure; monitors observe targets but do not own target runtime.
- New Relic accounts, Datadog child organizations, and Grafana Cloud stacks share a minimal observability tenant boundary.

Official sources:

- https://github.com/newrelic/terraform-provider-newrelic/releases/tag/v3.96.4
- https://registry.terraform.io/providers/newrelic/newrelic/3.96.4/docs
- https://docs.newrelic.com/docs/new-relic-control/fleet-control/overview/
- https://docs.newrelic.com/docs/synthetics/synthetic-monitoring/private-locations/private-locations-overview-monitor-internal-sites-add-new-locations/
- https://docs.newrelic.com/docs/service-level-management/create-slm/

## Result

Use six minimal core observability roles. Keep Fleet Control, telemetry
processing, workloads, and Federated Logs specific. No query, script, secret,
opaque definition, literal, or dependency becomes semantic evidence.
