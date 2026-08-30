terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.83.0"
    }
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "aws_vpc" "platform" {
  cidr_block = "10.20.0.0/16"
}

resource "aws_vpc_endpoint" "confluent" {
  vpc_id       = aws_vpc.platform.id
  service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-example"
}

resource "aws_kms_key" "streaming" {
  description = "Confluent streaming key"
}

resource "aws_iam_role" "confluent" {
  name               = "confluent-provider-integration"
  assume_role_policy = "{}"
}

resource "aws_s3_bucket" "tableflow" {
  bucket = "rootform-confluent-tableflow"
}

resource "aws_ec2_transit_gateway" "platform" {
  description = "Platform transit gateway"
}

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "eastus"
}

resource "azurerm_virtual_network" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.30.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.30.1.0/24"]
}

resource "azurerm_private_endpoint" "confluent" {
  name                = "confluent"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  subnet_id           = azurerm_subnet.private.id
}

resource "azurerm_key_vault_key" "streaming" {
  name         = "streaming"
  key_vault_id = "/subscriptions/example/resourceGroups/platform/providers/Microsoft.KeyVault/vaults/platform"
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt"]
}

resource "azurerm_storage_container" "tableflow" {
  name                  = "tableflow"
  storage_account_name  = "rootformtableflow"
  container_access_type = "private"
}

resource "google_compute_network" "platform" {
  name                    = "platform"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "private"
  ip_cidr_range = "10.40.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.platform.id
}

resource "google_compute_forwarding_rule" "confluent" {
  name                  = "confluent-psc"
  region                = "us-central1"
  load_balancing_scheme = ""
  network               = google_compute_network.platform.id
  subnetwork            = google_compute_subnetwork.private.id
  target                = "projects/example/regions/us-central1/serviceAttachments/confluent"
  psc_connection_id     = "123456789"
}

resource "google_kms_key_ring" "streaming" {
  name     = "streaming"
  location = "us-central1"
}

resource "google_kms_crypto_key" "streaming" {
  name     = "streaming"
  key_ring = google_kms_key_ring.streaming.id
}

resource "google_service_account" "confluent" {
  account_id   = "confluent-integration"
  display_name = "Confluent integration"
}

resource "google_storage_bucket" "tableflow" {
  name     = "rootform-confluent-tableflow"
  location = "US"
}

resource "confluent_environment" "source" {
  display_name = "Source"

  stream_governance {
    package = "ADVANCED"
  }
}

resource "confluent_environment" "destination" {
  display_name = "Destination"

  stream_governance {
    package = "ADVANCED"
  }
}

resource "confluent_network" "private" {
  display_name = "Private"
  cloud        = "AWS"
  region       = "us-east-1"
  cidr         = "10.50.0.0/16"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_gateway" "private" {
  display_name = "Private connectivity"

  environment {
    id = confluent_environment.source.id
  }

  aws_ingress_private_link_gateway {
    region = "us-east-1"
  }
}

resource "confluent_access_point" "aws" {
  display_name = "AWS ingress"

  environment {
    id = confluent_environment.source.id
  }

  gateway {
    id = confluent_gateway.private.id
  }

  aws_ingress_private_link_endpoint {
    vpc_endpoint_id = aws_vpc_endpoint.confluent.id
  }
}

resource "confluent_access_point" "azure" {
  display_name = "Azure ingress"

  environment {
    id = confluent_environment.source.id
  }

  gateway {
    id = confluent_gateway.private.id
  }

  azure_ingress_private_link_endpoint {
    private_endpoint_resource_id = azurerm_private_endpoint.confluent.id
  }
}

resource "confluent_access_point" "google" {
  display_name = "Google Cloud ingress"

  environment {
    id = confluent_environment.source.id
  }

  gateway {
    id = confluent_gateway.private.id
  }

  gcp_ingress_private_service_connect_endpoint {
    private_service_connect_connection_id = google_compute_forwarding_rule.confluent.psc_connection_id
  }
}

resource "confluent_peering" "aws" {
  display_name = "AWS peering"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  aws {
    account         = "111111111111"
    customer_region = "us-east-1"
    vpc             = aws_vpc.platform.id
  }
}

resource "confluent_peering" "azure" {
  display_name = "Azure peering"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  azure {
    customer_region = "eastus"
    tenant          = "example"
    vnet            = azurerm_virtual_network.platform.id
  }
}

resource "confluent_peering" "google" {
  display_name = "Google Cloud peering"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  gcp {
    project     = "example"
    vpc_network = google_compute_network.platform.id
  }
}

resource "confluent_private_link_access" "aws" {
  display_name = "AWS account access"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  aws {
    account = "111111111111"
  }
}

resource "confluent_private_link_attachment" "published" {
  display_name = "Published service"
  cloud        = "AWS"
  region       = "us-east-1"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_private_link_attachment_connection" "aws" {
  display_name = "AWS attachment connection"

  environment {
    id = confluent_environment.source.id
  }

  private_link_attachment {
    id = confluent_private_link_attachment.published.id
  }

  aws {
    vpc_endpoint_id = aws_vpc_endpoint.confluent.id
  }
}

resource "confluent_network_link_service" "shared" {
  display_name = "Shared network service"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }
}

resource "confluent_network_link_endpoint" "consumer" {
  display_name = "Shared network endpoint"

  environment {
    id = confluent_environment.destination.id
  }

  network {
    id = confluent_network.private.id
  }

  network_link_service {
    id = confluent_network_link_service.shared.id
  }
}

resource "confluent_transit_gateway_attachment" "platform" {
  display_name = "Platform transit"

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  aws {
    transit_gateway_id = aws_ec2_transit_gateway.platform.id
  }
}

resource "confluent_dns_forwarder" "private" {
  display_name = "Private DNS"

  environment {
    id = confluent_environment.source.id
  }

  gateway {
    id = confluent_gateway.private.id
  }

  domains = ["internal.example.com"]
}

resource "confluent_dns_record" "private" {
  domain = "service.internal.example.com"
  type   = "A"
  values = ["10.50.0.10"]
}

resource "confluent_byok_key" "aws" {
  aws {
    key_arn = aws_kms_key.streaming.arn
  }
}

resource "confluent_byok_key" "azure" {
  azure {
    key_identifier = azurerm_key_vault_key.streaming.id
    key_vault_id   = azurerm_key_vault_key.streaming.key_vault_id
    tenant_id      = "example"
  }
}

resource "confluent_byok_key" "google" {
  gcp {
    key_id = google_kms_crypto_key.streaming.id
  }
}

resource "confluent_provider_integration" "aws" {
  display_name = "AWS integration"

  environment {
    id = confluent_environment.source.id
  }

  aws {
    customer_role_arn = aws_iam_role.confluent.arn
  }
}

resource "confluent_provider_integration_authorization" "google" {
  provider_integration_id = confluent_provider_integration.aws.id

  environment {
    id = confluent_environment.source.id
  }

  gcp {
    customer_google_service_account = google_service_account.confluent.email
  }
}

resource "confluent_provider_integration_setup" "aws" {
  display_name = "AWS integration setup"
  cloud        = "AWS"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_kafka_cluster" "source" {
  display_name = "Source Kafka"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = "us-east-1"

  dedicated {
    cku = 2
  }

  environment {
    id = confluent_environment.source.id
  }

  network {
    id = confluent_network.private.id
  }

  byok_key {
    id = confluent_byok_key.aws.id
  }
}

resource "confluent_kafka_cluster" "destination" {
  display_name = "Destination Kafka"
  availability = "MULTI_ZONE"
  cloud        = "GCP"
  region       = "us-central1"

  dedicated {
    cku = 2
  }

  environment {
    id = confluent_environment.destination.id
  }
}

resource "confluent_kafka_topic" "orders" {
  topic_name       = "orders"
  partitions_count = 12

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
}

resource "confluent_rtce_topic" "context" {
  display_name = "Context"
  cloud        = "AWS"
  region       = "us-east-1"
  topic_name   = "context"

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
}

resource "confluent_cluster_link" "replication" {
  link_name = "replication"

  source_kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  destination_kafka_cluster {
    id = confluent_kafka_cluster.destination.id
  }
}

resource "confluent_kafka_mirror_topic" "orders" {
  mirror_topic_name = "orders-mirror"

  kafka_cluster {
    id = confluent_kafka_cluster.destination.id
  }

  cluster_link {
    link_name = confluent_cluster_link.replication.link_name
  }

  source_kafka_topic {
    topic_name = confluent_kafka_topic.orders.topic_name
  }
}

resource "confluent_kafka_acl" "connector" {
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.orders.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:connector"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
}

resource "confluent_kafka_client_quota" "connector" {
  display_name = "Connector quota"

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
}

resource "confluent_kafka_cluster_config" "source" {
  config = {
    "auto.create.topics.enable" = "false"
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
}

resource "confluent_service_account" "processor" {
  display_name = "Processor"
  description  = "Flink and connector principal"
}

resource "confluent_connector" "warehouse" {
  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  config_nonsensitive = {
    "connector.class"          = "S3_SINK"
    "topics"                   = confluent_kafka_topic.orders.topic_name
    "kafka.service.account.id" = confluent_service_account.processor.id
    "s3.bucket.name"           = aws_s3_bucket.tableflow.bucket
  }

  config_sensitive = {
    "aws.secret.access.key" = "ROOTFORM_CONFLUENT_CONNECTOR_SECRET"
  }

  depends_on = [google_storage_bucket.tableflow]
}

resource "confluent_connect_artifact" "connector" {
  display_name  = "Connector artifact"
  cloud         = "AWS"
  artifact_file = "connector.zip"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_custom_connector_plugin" "connector" {
  display_name    = "Custom connector"
  cloud           = "AWS"
  connector_class = "com.example.CustomConnector"
  connector_type  = "SINK"
  filename        = "connector.zip"
}

resource "confluent_custom_connector_plugin_version" "connector" {
  plugin_id = confluent_custom_connector_plugin.connector.id
  cloud     = "AWS"
  filename  = "connector-v2.zip"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_plugin" "legacy" {
  display_name = "Legacy connector plugin"
  cloud        = "AWS"
  filename     = "legacy.zip"
}

resource "confluent_flink_compute_pool" "analytics" {
  display_name = "Analytics"
  cloud        = "AWS"
  region       = "us-east-1"
  max_cfu      = 20

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_flink_compute_pool_config" "defaults" {
  default_compute_pool_enabled = true
  default_max_cfu              = 20
}

resource "confluent_flink_connection" "warehouse" {
  display_name = "Warehouse"
  type         = "snowflake"
  endpoint     = "warehouse.example.com"
  password     = "ROOTFORM_CONFLUENT_FLINK_PASSWORD"

  compute_pool {
    id = confluent_flink_compute_pool.analytics.id
  }

  environment {
    id = confluent_environment.source.id
  }

  principal {
    id = confluent_service_account.processor.id
  }
}

resource "confluent_flink_materialized_table" "orders" {
  display_name = "Orders"
  query        = "ROOTFORM_CONFLUENT_MATERIALIZED_TABLE_QUERY"

  compute_pool {
    id = confluent_flink_compute_pool.analytics.id
  }

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  principal {
    id = confluent_service_account.processor.id
  }
}

resource "confluent_flink_statement" "orders" {
  statement_name       = "orders"
  statement            = "ROOTFORM_CONFLUENT_FLINK_SQL_SENTINEL"
  properties_sensitive = { password = "ROOTFORM_CONFLUENT_FLINK_PROPERTY_SECRET" }

  compute_pool {
    id = confluent_flink_compute_pool.analytics.id
  }

  environment {
    id = confluent_environment.source.id
  }

  principal {
    id = confluent_service_account.processor.id
  }
}

resource "confluent_flink_artifact" "analytics" {
  display_name     = "Analytics artifact"
  cloud            = "AWS"
  region           = "us-east-1"
  artifact_file    = "analytics.jar"
  runtime_language = "JAVA"

  environment {
    id = confluent_environment.source.id
  }
}

resource "confluent_ksql_cluster" "analytics" {
  display_name = "Analytics"
  csu          = 4

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  credential_identity {
    id = confluent_service_account.processor.id
  }
}

data "confluent_schema_registry_cluster" "source" {
  environment {
    id = confluent_environment.source.id
  }
}

data "confluent_schema_registry_cluster" "destination" {
  environment {
    id = confluent_environment.destination.id
  }
}

resource "confluent_schema" "order" {
  subject_name = "orders-value"
  format       = "AVRO"
  schema       = "ROOTFORM_CONFLUENT_SCHEMA_SENTINEL"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_schema_registry_cluster_config" "source" {
  compatibility_level = "BACKWARD"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_schema_registry_cluster_mode" "source" {
  mode = "READWRITE"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_schema_registry_kek" "source" {
  name       = "orders"
  kms_type   = "aws-kms"
  kms_key_id = aws_kms_key.streaming.arn

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_schema_registry_dek" "source" {
  kek_name     = confluent_schema_registry_kek.source.name
  subject_name = "orders-value"
  key_material = "ROOTFORM_CONFLUENT_DEK_SENTINEL"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_subject_config" "orders" {
  subject_name        = "orders-value"
  compatibility_level = "BACKWARD"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_subject_mode" "orders" {
  subject_name = "orders-value"
  mode         = "READWRITE"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }
}

resource "confluent_schema_exporter" "replication" {
  name = "replication"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.source.id
  }

  destination_schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.destination.id
  }
}

resource "confluent_catalog_integration" "glue" {
  display_name = "AWS Glue"

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  aws_glue {
    provider_integration_id = confluent_provider_integration.aws.id
  }
}

resource "confluent_tableflow_topic" "aws" {
  display_name = "Orders Iceberg"

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  byob_aws {
    bucket_name            = aws_s3_bucket.tableflow.bucket
    bucket_region          = "us-east-1"
    provider_integration_id = confluent_provider_integration.aws.id
  }
}

resource "confluent_tableflow_topic" "azure" {
  display_name = "Orders Delta"

  environment {
    id = confluent_environment.source.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }

  azure_data_lake_storage_gen_2 {
    container_name         = azurerm_storage_container.tableflow.name
    storage_account_name   = "rootformtableflow"
    storage_region         = "eastus"
    provider_integration_id = confluent_provider_integration.aws.id
  }
}

resource "confluent_identity_provider" "workforce" {
  display_name = "Workforce"
  issuer       = "https://identity.example.com"
  jwks_uri     = "https://identity.example.com/.well-known/jwks.json"
}

resource "confluent_identity_pool" "workforce" {
  display_name = "Workforce"
  filter       = "claims.sub != null"

  identity_provider {
    id = confluent_identity_provider.workforce.id
  }
}

resource "confluent_group_mapping" "platform" {
  display_name = "Platform"
  filter       = "claims.groups.contains('platform')"
}

resource "confluent_role_binding" "platform" {
  principal   = "User:${confluent_service_account.processor.id}"
  role_name   = "DeveloperRead"
  crn_pattern = confluent_kafka_cluster.source.rbac_crn
}

resource "confluent_ip_group" "office" {
  display_name = "Office"
  cidr_blocks  = ["203.0.113.0/24"]
}

resource "confluent_ip_filter" "office" {
  display_name = "Office"
  resource_group = "multiple"
  ip_groups = [confluent_ip_group.office.id]
}

resource "confluent_certificate_authority" "clients" {
  display_name              = "Clients"
  certificate_chain         = "ROOTFORM_CONFLUENT_CERTIFICATE_SENTINEL"
  require_crl_on_client_certificate = false
}

resource "confluent_certificate_pool" "clients" {
  display_name = "Clients"
  filter       = "subject.cn == 'client'"

  certificate_authority {
    id = confluent_certificate_authority.clients.id
  }
}

resource "confluent_business_metadata" "owner" {
  display_name = "Owner"
}

resource "confluent_business_metadata_binding" "orders" {
  business_metadata_name = confluent_business_metadata.owner.name
  entity_name            = confluent_kafka_topic.orders.topic_name
}

resource "confluent_catalog_entity_attributes" "orders" {
  entity_name = confluent_kafka_topic.orders.topic_name
  attributes  = { owner = "platform" }
}

resource "confluent_tag" "critical" {
  display_name = "Critical"
}

resource "confluent_tag_binding" "orders" {
  tag_name    = confluent_tag.critical.name
  entity_name = confluent_kafka_topic.orders.topic_name
}
