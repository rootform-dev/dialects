# SPEC-066 provider boundaries spike

- Date: 2026-08-29
- Result: Pass
- Time box: 75 minutes

## Question

Can provider `2.83.0` produce broad Confluent Cloud architecture and honest
multi-cloud facts without changing core, Rootform Language, Architecture IR, or renderer?

## Evidence

Provider tag `v2.83.0` resolves to commit
`c8ac24df1fa4eafd677ced5b9f6d52d9009c9946` and tree
`6e07705f6577828aea09bef7249bc13dffe9bf6d`, published 2026-08-12. Terraform
1.12.2 captured a 248,250-byte schema with SHA-256
`9d01161496826c366746c93c53f358e6d66b0120ab86653c2e2e057b1feb3731`:
64 resources, 63 data sources, and no ephemeral resources, functions, or
resource identities. The darwin/arm64 release archive SHA-256 is
`bae06209ba909845b0a87187531703c8f7ad5d4760fd9bd73e84c53bea075d22`.

Confluent documentation establishes one logical Schema Registry per
environment, compute pools as regional resources running Flink statements,
connectors as managed links between Kafka and external systems, and Cluster
Links as persistent bridges between explicit source and destination clusters.
Mirror topics provide documented replication direction. Ordinary topic
presence establishes none.

Network, peering, gateway, access-point, attachment, and provider-integration
resources expose fixed IDs that Rootform can resolve. Literal cloud account,
subscription, project, endpoint, or service-attachment strings identify no
Terraform declaration. Connector configuration is an opaque map: exact
references can prove neutral attachment to a represented service, but connector
class and direction cannot be matched safely with current primitives.

Schema content, Flink SQL, connector secrets, API keys, DEK/KEK material, and
credentials must never enter architecture or logs. They are not needed for any
accepted fact. Provider data sources remain read-only inventory except the
Schema Registry cluster surface: the provider has no managed cluster resource,
while official product semantics make that environment-level service durable.

No core promotion is justified. Existing identities cover virtual network,
message topic, service identity, network peering, private endpoint, and
encryption key. Kafka cluster, Schema Registry, Cluster Linking, Flink compute,
connectors, and Confluent network topology stay local.

No Confluent logo redistribution permission was found in official product or
provider terms. Use approved generic presentation identities and official text labels.

## Official sources

- <https://github.com/confluentinc/terraform-provider-confluent/releases/tag/v2.83.0>
- <https://registry.terraform.io/providers/confluentinc/confluent/2.83.0/docs>
- <https://docs.confluent.io/cloud/current/get-started/confluent-cloud-basics.html>
- <https://docs.confluent.io/cloud/current/networking/overview.html>
- <https://docs.confluent.io/cloud/current/networking/resource-overview.html>
- <https://docs.confluent.io/cloud/current/multi-cloud/cluster-linking/index.html>
- <https://docs.confluent.io/cloud/current/connectors/overview.html>
- <https://docs.confluent.io/cloud/current/flink/overview.html>
- <https://docs.confluent.io/cloud/current/flink/concepts/compute-pools.html>
- <https://docs.confluent.io/cloud/current/get-started/schema-registry.html>

## Verdict

Proceed with exact temporary compatibility, exhaustive decisions, selected
data-source representation, fixed-path proof, neutral connector facts, explicit
Cluster Linking direction, no new core/Language/IR contract, and generic assets.
