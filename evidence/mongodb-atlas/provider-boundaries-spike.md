# MongoDB Atlas provider-boundaries spike

- Result: Resolved
- Date: 2026-08-29
- Provider: `mongodb/mongodbatlas` `2.16.0`
- Decision: ADR-085

## Findings

- Terraform `1.12.2` loaded schema without Atlas credentials or provider configuration: 75 resources, 141 data sources, one ephemeral resource.
- Organization owns projects; projects isolate clusters, networks, access, alerts, and security configuration.
- Cluster resources expose project and deployment configuration. Cloud/provider/region literals do not identify Terraform cloud resources.
- Network peering exposes cloud-network identifiers suitable for exact AWS VPC, Azure VNet, and Google Cloud VPC resolution.
- Dedicated-cluster private endpoint resources expose project/provider/region and endpoint registration, but no cluster input; direct cluster relation would be inferred.
- Encryption-at-rest exposes provider-specific customer-key fields suitable for exact KMS/key resolution.
- Data Federation storage configuration names Atlas clusters and AWS/Azure/Google object stores; Stream Processing connections register neutral sources/sinks while processor pipeline text carries direction.

## Sources

- https://registry.terraform.io/providers/mongodb/mongodbatlas/2.16.0/docs
- https://github.com/mongodb/terraform-provider-mongodbatlas/tree/v2.16.0/docs
- https://www.mongodb.com/docs/atlas/organizations-projects/
- https://www.mongodb.com/docs/atlas/security-private-endpoint/
- https://www.mongodb.com/docs/atlas/manage-vpc-peering/
- https://www.mongodb.com/docs/atlas/security-kms-encryption/
- https://www.mongodb.com/docs/atlas/data-federation/adf-overview/architecture/
- https://www.mongodb.com/docs/atlas/atlas-stream-processing/architecture/
