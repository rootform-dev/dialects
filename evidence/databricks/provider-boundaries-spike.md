# Databricks provider-boundaries spike

- Date: 2026-08-29
- Result: resolved
- Baseline: `databricks/databricks` `1.129.0`

## Observations

- Terraform `1.12.2` schema RPC, with Databricks and cloud credentials unset, returned 175 managed resources and 186 data sources; schema format `1.0`.
- `databricks_mws_workspaces` creates AWS and Google Cloud workspaces. Azure workspace creation belongs to `azurerm_databricks_workspace`.
- Workspace-level resources normally derive their workspace from provider configuration. Provider alias, host, authentication, and implicit configuration are not architecture facts available to Rootform.
- `databricks_metastore_assignment` explicitly names workspace and metastore. MWS workspace resources explicitly name network, storage, credential, key, and private-access registrations.
- Unity Catalog external locations explicitly combine a cloud storage URL and storage credential. Storage credential blocks explicitly name AWS roles, Azure managed identities/access connectors, or Google service accounts; secret fields are marked sensitive.
- MWS network objects register customer VPC/subnet and private endpoint resources. NCCs are regional Databricks constructs attached to workspaces; private endpoint rules name their target through dedicated fields.
- Jobs and Lakeflow pipelines are durable orchestration boundaries. Tasks, notebooks, SQL text, refresh operations, permissions, and settings are supporting or operational objects.

## Resolution

- Represent explicit account/workspace, Unity Catalog, compute, orchestration, serving, sharing, application, Lakebase, and network owners.
- Emit no implicit workspace ownership. Use metastore assignment, MWS registration fields, `provider_config.workspace_id` only when present in the resource input, and successful Rootform resolution.
- Keep Databricks network registrations distinct from cloud VPC/VNet resources, then relate them through exact dedicated IDs. Never relabel a registration as the cloud network itself.
- Represent external locations and storage credentials; relate cloud storage and identity only from dedicated documented fields. Never parse opaque option maps or emit secret values.
- Treat all baseline data sources as read-only lookup surfaces because every durable candidate has a managed resource in this baseline.
- Keep exact `= 1.129.0` as temporary evidence bound. Later compatible versions may widen without a new dialect release after schema/path/meaning comparison.
- No Rootform Language, IR, core, policy, parser, layout, or renderer change is required.
