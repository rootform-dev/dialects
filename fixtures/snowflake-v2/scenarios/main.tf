terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "8.0.0"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "2.20.0"
    }
  }
}

resource "aws_s3_bucket" "lake" {
  bucket = "rootform-snowflake-lake"
}

resource "aws_iam_role" "snowflake" {
  name               = "rootform-snowflake"
  assume_role_policy = "ROOTFORM_SNOWFLAKE_AWS_TRUST_SENTINEL"
}

resource "aws_kms_key" "lake" {
  description = "Snowflake stage key"
}

resource "aws_sns_topic" "snowpipe" {
  name = "rootform-snowpipe"
}

resource "aws_sqs_queue" "notifications" {
  name = "rootform-snowflake-notifications"
}

resource "aws_api_gateway_rest_api" "external_function" {
  name = "rootform-snowflake"
}

resource "azurerm_resource_group" "snowflake" {
  name     = "rg-snowflake"
  location = "West Europe"
}

resource "azurerm_storage_account" "lake" {
  name                     = "rootformsnowflake"
  resource_group_name      = azurerm_resource_group.snowflake.name
  location                 = azurerm_resource_group.snowflake.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lake" {
  name               = "lake"
  storage_account_id = azurerm_storage_account.lake.id
}

resource "azurerm_storage_queue" "notifications" {
  name                 = "snowflake-notifications"
  storage_account_name = azurerm_storage_account.lake.name
}

resource "azurerm_user_assigned_identity" "snowflake" {
  name                = "id-snowflake"
  resource_group_name = azurerm_resource_group.snowflake.name
  location            = azurerm_resource_group.snowflake.location
}

resource "azurerm_api_management" "external_function" {
  name                = "apim-snowflake"
  location            = azurerm_resource_group.snowflake.location
  resource_group_name = azurerm_resource_group.snowflake.name
  publisher_name      = "Rootform"
  publisher_email     = "platform@example.invalid"
  sku_name            = "Developer_1"
}

resource "google_storage_bucket" "lake" {
  name     = "rootform-snowflake-lake"
  location = "US"
}

resource "google_service_account" "snowflake" {
  account_id   = "rootform-snowflake"
  display_name = "Snowflake"
}

resource "google_kms_key_ring" "snowflake" {
  name     = "snowflake"
  location = "us-central1"
}

resource "google_kms_crypto_key" "lake" {
  name     = "lake"
  key_ring = google_kms_key_ring.snowflake.id
}

resource "google_pubsub_topic" "snowpipe" {
  name = "snowpipe"
}

resource "google_pubsub_subscription" "snowpipe" {
  name  = "snowpipe"
  topic = google_pubsub_topic.snowpipe.id
}

resource "google_api_gateway_gateway" "external_function" {
  gateway_id = "snowflake"
  api_config = "projects/rootform/locations/global/apis/snowflake/configs/current"
}

resource "snowflake_account" "platform" {
  name           = "ROOTFORM_PLATFORM"
  admin_name     = "ROOTFORM_ADMIN"
  admin_password = "ROOTFORM_SNOWFLAKE_ADMIN_PASSWORD_SENTINEL"
  email          = "platform@example.invalid"
  edition        = "ENTERPRISE"
  region         = "AWS_US_EAST_1"
}

resource "snowflake_database" "analytics" {
  name = "ANALYTICS"
}

resource "snowflake_schema" "pipelines" {
  database = snowflake_database.analytics.fully_qualified_name
  name     = "PIPELINES"
}

resource "snowflake_warehouse" "transform" {
  name = "TRANSFORM"
}

resource "snowflake_dynamic_table" "orders" {
  database  = snowflake_database.analytics.name
  schema    = snowflake_schema.pipelines.fully_qualified_name
  name      = "ORDERS"
  warehouse = snowflake_warehouse.transform.fully_qualified_name
  query     = "select 1"
}

resource "snowflake_storage_integration_aws" "lake" {
  name                      = "AWS_LAKE"
  storage_aws_role_arn      = aws_iam_role.snowflake.arn
  storage_allowed_locations = [aws_s3_bucket.lake.id]
}

resource "snowflake_storage_integration_azure" "lake" {
  name                      = "AZURE_LAKE"
  azure_tenant_id           = "00000000-0000-0000-0000-000000000000"
  storage_allowed_locations = [azurerm_storage_container.lake.id]
}

resource "snowflake_storage_integration_gcs" "lake" {
  name                      = "GCS_LAKE"
  storage_allowed_locations = [google_storage_bucket.lake.id]
}

resource "snowflake_notification_integration" "aws" {
  name               = "AWS_NOTIFICATIONS"
  direction          = "OUTBOUND"
  notification_provider = "AWS_SNS"
  aws_sns_topic_arn  = aws_sns_topic.snowpipe.arn
  aws_sqs_arn        = aws_sqs_queue.notifications.arn
  aws_sns_role_arn   = aws_iam_role.snowflake.arn
}

resource "snowflake_notification_integration" "azure" {
  name                            = "AZURE_NOTIFICATIONS"
  direction                       = "INBOUND"
  notification_provider           = "AZURE_STORAGE_QUEUE"
  azure_storage_queue_primary_uri = azurerm_storage_queue.notifications.id
  azure_tenant_id                 = "00000000-0000-0000-0000-000000000000"
}

resource "snowflake_notification_integration" "google" {
  name                          = "GCP_NOTIFICATIONS"
  direction                     = "INBOUND"
  notification_provider         = "GCP_PUBSUB"
  gcp_pubsub_topic_name         = google_pubsub_topic.snowpipe.id
  gcp_pubsub_subscription_name  = google_pubsub_subscription.snowpipe.id
}

resource "snowflake_stage_external_s3" "aws" {
  database            = snowflake_database.analytics.name
  schema              = snowflake_schema.pipelines.fully_qualified_name
  name                = "AWS_STAGE"
  url                 = aws_s3_bucket.lake.id
  storage_integration = snowflake_storage_integration_aws.lake.fully_qualified_name

  credentials {
    aws_role = aws_iam_role.snowflake.arn
  }

  directory {
    enable        = "true"
    auto_refresh  = "true"
    aws_sns_topic = aws_sns_topic.snowpipe.arn
  }

  encryption {
    aws_sse_kms {
      kms_key_id = aws_kms_key.lake.id
    }
  }
}

resource "snowflake_stage_external_azure" "azure" {
  database            = snowflake_database.analytics.name
  schema              = snowflake_schema.pipelines.fully_qualified_name
  name                = "AZURE_STAGE"
  url                 = azurerm_storage_container.lake.id
  storage_integration = snowflake_storage_integration_azure.lake.fully_qualified_name

  directory {
    enable                   = "true"
    auto_refresh             = "true"
    notification_integration = snowflake_notification_integration.azure.fully_qualified_name
  }
}

resource "snowflake_stage_external_gcs" "google" {
  database            = snowflake_database.analytics.name
  schema              = snowflake_schema.pipelines.fully_qualified_name
  name                = "GCS_STAGE"
  url                 = google_storage_bucket.lake.id
  storage_integration = snowflake_storage_integration_gcs.lake.fully_qualified_name

  directory {
    enable                   = "true"
    auto_refresh             = "true"
    notification_integration = snowflake_notification_integration.google.fully_qualified_name
  }

  encryption {
    gcs_sse_kms {
      kms_key_id = google_kms_crypto_key.lake.id
    }
  }
}

resource "snowflake_pipe" "orders" {
  database          = snowflake_database.analytics.name
  schema            = snowflake_schema.pipelines.fully_qualified_name
  name              = "ORDERS"
  auto_ingest       = true
  integration       = snowflake_notification_integration.aws.fully_qualified_name
  aws_sns_topic_arn = aws_sns_topic.snowpipe.arn
  copy_statement    = "copy into orders from @aws_stage"
}

resource "snowflake_task" "load" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "LOAD"
  warehouse     = snowflake_warehouse.transform.fully_qualified_name
  sql_statement = "select 1"
}

resource "snowflake_task" "publish" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "PUBLISH"
  warehouse     = snowflake_warehouse.transform.fully_qualified_name
  after         = [snowflake_task.load.fully_qualified_name]
  sql_statement = "select 1"
}

resource "snowflake_api_integration_amazon_api_gateway" "aws" {
  name                 = "AWS_API"
  api_allowed_prefixes = [aws_api_gateway_rest_api.external_function.id]
  api_aws_role_arn     = aws_iam_role.snowflake.arn
}

resource "snowflake_api_integration_azure_api_management" "azure" {
  name                 = "AZURE_API"
  api_allowed_prefixes = [azurerm_api_management.external_function.id]
  azure_tenant_id      = "00000000-0000-0000-0000-000000000000"
  azure_ad_application_id = "00000000-0000-0000-0000-000000000000"
}

resource "snowflake_api_integration_google_cloud_api_gateway" "google" {
  name                 = "GCP_API"
  api_allowed_prefixes = [google_api_gateway_gateway.external_function.id]
  google_audience      = "rootform"
}

resource "snowflake_external_function" "score" {
  database                  = snowflake_database.analytics.name
  schema                    = snowflake_schema.pipelines.fully_qualified_name
  name                      = "SCORE"
  api_integration           = snowflake_api_integration_amazon_api_gateway.aws.fully_qualified_name
  url_of_proxy_and_resource = "https://example.invalid/score"
  return_type               = "VARIANT"
}

resource "snowflake_network_rule" "egress" {
  database   = snowflake_database.analytics.name
  schema     = snowflake_schema.pipelines.fully_qualified_name
  name       = "EGRESS"
  mode       = "EGRESS"
  type       = "HOST_PORT"
  value_list = ["example.invalid:443"]
}

resource "snowflake_external_access_integration" "egress" {
  name                  = "EGRESS"
  allowed_network_rules = [snowflake_network_rule.egress.fully_qualified_name]
}

resource "snowflake_stage_internal" "code" {
  database = snowflake_database.analytics.name
  schema   = snowflake_schema.pipelines.fully_qualified_name
  name     = "CODE"
}

resource "snowflake_compute_pool" "applications" {
  name            = "APPLICATIONS"
  min_nodes       = 1
  max_nodes       = 2
  instance_family = "CPU_X64_XS"
}

resource "snowflake_image_repository" "applications" {
  database = snowflake_database.analytics.name
  schema   = snowflake_schema.pipelines.fully_qualified_name
  name     = "APPLICATIONS"
}

resource "snowflake_service" "application" {
  database                     = snowflake_database.analytics.name
  schema                       = snowflake_schema.pipelines.fully_qualified_name
  name                         = "APPLICATION"
  compute_pool                 = snowflake_compute_pool.applications.fully_qualified_name
  query_warehouse              = snowflake_warehouse.transform.fully_qualified_name
  external_access_integrations = [snowflake_external_access_integration.egress.fully_qualified_name]

  from_specification {
    stage = snowflake_stage_internal.code.fully_qualified_name
    path  = "/"
    file  = "spec.yaml"
  }
}

resource "snowflake_cortex_search_service" "documents" {
  database   = snowflake_database.analytics.name
  schema     = snowflake_schema.pipelines.fully_qualified_name
  name       = "DOCUMENTS"
  warehouse  = snowflake_warehouse.transform.fully_qualified_name
  target_lag = "1 hour"
  query      = "select text from documents"
  on         = "text"
}

resource "snowflake_cortex_agent" "analyst" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "ANALYST"
  specification = "ROOTFORM_SNOWFLAKE_AGENT_SPEC_SENTINEL"
}

resource "snowflake_mcp_server" "governed" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "GOVERNED"
  specification = "ROOTFORM_SNOWFLAKE_MCP_SPEC_SENTINEL"
}

resource "snowflake_streamlit" "dashboard" {
  database        = snowflake_database.analytics.name
  schema          = snowflake_schema.pipelines.fully_qualified_name
  name            = "DASHBOARD"
  stage           = snowflake_stage_internal.code.fully_qualified_name
  main_file       = "app.py"
  query_warehouse = snowflake_warehouse.transform.fully_qualified_name
}

resource "snowflake_service_user" "automation" {
  name             = "AUTOMATION"
  default_warehouse = snowflake_warehouse.transform.fully_qualified_name
  rsa_public_key   = "ROOTFORM_SNOWFLAKE_RSA_PUBLIC_KEY_SENTINEL"
}

resource "snowflake_share" "analytics" {
  name = "ANALYTICS_SHARE"
}

resource "snowflake_listing" "analytics" {
  name  = "ANALYTICS_LISTING"
  share = snowflake_share.analytics.fully_qualified_name

  manifest {
    from_string = "title: Rootform analytics"
  }
}

resource "snowflake_secret_with_generic_string" "credential" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.name
  name          = "PRIVATE_CREDENTIAL"
  secret_string = "ROOTFORM_SNOWFLAKE_SECRET_SENTINEL"
}

data "snowflake_warehouses" "lookup" {
  like = snowflake_warehouse.transform.name
}
