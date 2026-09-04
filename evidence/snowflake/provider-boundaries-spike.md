# Snowflake provider-boundaries spike

- Result: Resolved
- Date: 2026-08-30
- Provider: `snowflakedb/snowflake` `2.20.0`

Terraform `1.12.2` loaded schema without Snowflake credentials or provider
configuration: 143 resources and 65 data sources. Snowflake accounts contain
databases; schemas own named stages, pipes, tasks, functions, applications, and
AI services. Virtual warehouses are independent compute clusters: provider does
not assign one to a database. Workloads referencing both prove connectivity.

Storage integrations and stages expose cloud storage/identity fields. Notification
integrations expose AWS SNS/SQS, Azure Storage Queue, and Google Pub/Sub fields.
These fields prove relations only when Terraform traversals resolve to represented
resources. URLs, SQL bodies, string identifiers, cloud/region values, and provider
configuration prove none.

Snowpark Container Services uses image repositories, compute pools, and services.
Cortex Agents and Cortex Search remain distinct Snowflake services. SQL object,
grant, policy, credential, token, and lookup surfaces do not become topology.

Sources:

- https://registry.terraform.io/providers/snowflakedb/snowflake/2.20.0/docs
- https://github.com/snowflakedb/terraform-provider-snowflake/tree/v2.20.0/docs
- https://docs.snowflake.com/en/user-guide/intro-key-concepts
- https://docs.snowflake.com/en/user-guide/data-load-overview
- https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration
- https://docs.snowflake.com/en/user-guide/notifications/about-notifications
- https://docs.snowflake.com/en/user-guide/tasks-intro
- https://docs.snowflake.com/en/developer-guide/snowpark-container-services/overview
- https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-agents
