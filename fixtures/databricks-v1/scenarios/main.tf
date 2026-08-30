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
    databricks = {
      source  = "databricks/databricks"
      version = "1.129.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "8.0.0"
    }
  }
}

resource "aws_vpc" "platform" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.platform.id
  cidr_block = "10.10.1.0/24"
}

resource "aws_vpc_endpoint" "databricks" {
  vpc_id       = aws_vpc.platform.id
  service_name = "com.amazonaws.vpce.us-east-1.databricks"
}

resource "aws_s3_bucket" "root" {
  bucket = "rootform-databricks-root"
}

resource "aws_s3_bucket" "data" {
  bucket = "rootform-databricks-data"
}

resource "aws_iam_role" "databricks" {
  name               = "rootform-databricks"
  assume_role_policy = "{}"
}

resource "aws_kms_key" "workspace" {
  description = "Databricks workspace key"
}

resource "azurerm_resource_group" "platform" {
  name     = "rg-databricks"
  location = "West Europe"
}

resource "azurerm_virtual_network" "platform" {
  name                = "vnet-databricks"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_storage_account" "data" {
  name                     = "rootformdatabricks"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.data.id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "databricks" {
  name                = "id-databricks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
}

resource "azurerm_private_endpoint" "databricks" {
  name                = "pe-databricks"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  subnet_id           = azurerm_subnet.private.id
}

resource "google_compute_network" "platform" {
  name                    = "databricks-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "databricks-private"
  network       = google_compute_network.platform.id
  ip_cidr_range = "10.30.0.0/20"
  region        = "us-central1"
}

resource "google_compute_forwarding_rule" "databricks" {
  name                  = "databricks-psc"
  network               = google_compute_network.platform.id
  subnetwork            = google_compute_subnetwork.private.id
  load_balancing_scheme = ""
}

resource "google_storage_bucket" "data" {
  name     = "rootform-databricks-data"
  location = "US"
}

resource "google_service_account" "databricks" {
  account_id   = "rootform-databricks"
  display_name = "Databricks"
}

resource "google_kms_key_ring" "platform" {
  name     = "databricks"
  location = "us-central1"
}

resource "google_kms_crypto_key" "workspace" {
  name     = "workspace"
  key_ring = google_kms_key_ring.platform.id
}

resource "databricks_mws_credentials" "aws" {
  account_id       = "account"
  credentials_name = "aws-deployment"
  role_arn         = aws_iam_role.databricks.arn
}

resource "databricks_mws_storage_configurations" "aws" {
  account_id                 = "account"
  storage_configuration_name = "aws-root"
  bucket_name                = aws_s3_bucket.root.id
  role_arn                   = aws_iam_role.databricks.arn
}

resource "databricks_mws_customer_managed_keys" "aws" {
  account_id = "account"
  use_cases  = ["MANAGED_SERVICES", "STORAGE"]

  aws_key_info {
    key_arn    = aws_kms_key.workspace.arn
    key_region = "us-east-1"
  }
}

resource "databricks_mws_networks" "aws" {
  account_id         = "account"
  network_name       = "aws-network"
  vpc_id             = aws_vpc.platform.id
  subnet_ids         = [aws_subnet.private.id]
  security_group_ids = []
}

resource "databricks_mws_vpc_endpoint" "aws" {
  account_id          = "account"
  vpc_endpoint_name   = "aws-private-link"
  aws_vpc_endpoint_id = aws_vpc_endpoint.databricks.id
}

resource "databricks_mws_private_access_settings" "aws" {
  account_id                   = "account"
  private_access_settings_name = "aws-private"
  region                       = "us-east-1"
  public_access_enabled        = false
}

resource "databricks_mws_network_connectivity_config" "serverless" {
  account_id = "account"
  name       = "serverless-private"
  region     = "us-east-1"
}

resource "databricks_mws_workspaces" "aws" {
  account_id                     = "account"
  workspace_name                 = "aws-platform"
  aws_region                     = "us-east-1"
  credentials_id                 = databricks_mws_credentials.aws.credentials_id
  storage_configuration_id       = databricks_mws_storage_configurations.aws.storage_configuration_id
  network_id                     = databricks_mws_networks.aws.network_id
  private_access_settings_id     = databricks_mws_private_access_settings.aws.private_access_settings_id
  network_connectivity_config_id = databricks_mws_network_connectivity_config.serverless.network_connectivity_config_id
}

resource "databricks_mws_ncc_binding" "aws" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.serverless.network_connectivity_config_id
  workspace_id                   = databricks_mws_workspaces.aws.workspace_id
}

resource "databricks_mws_ncc_private_endpoint_rule" "azure_storage" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.serverless.network_connectivity_config_id
  resource_id                    = azurerm_storage_container.data.id
  group_id                       = "blob"
}

resource "databricks_mws_networks" "google" {
  account_id   = "account"
  network_name = "google-network"

  gcp_network_info {
    network_project_id = "rootform-project"
    vpc_id             = google_compute_network.platform.name
    subnet_id          = google_compute_subnetwork.private.name
    subnet_region      = google_compute_subnetwork.private.region
  }
}

resource "databricks_mws_vpc_endpoint" "google" {
  account_id        = "account"
  vpc_endpoint_name = "google-psc"

  gcp_vpc_endpoint_info {
    endpoint_region   = "us-central1"
    project_id        = "rootform-project"
    psc_endpoint_name = google_compute_forwarding_rule.databricks.name
  }
}

resource "databricks_endpoint" "azure" {
  parent       = "accounts/account"
  display_name = "azure-service-direct"
  region       = "westeurope"

  azure_private_endpoint_info = {
    private_endpoint_name          = azurerm_private_endpoint.databricks.name
    private_endpoint_resource_guid = "00000000-0000-0000-0000-000000000000"
    private_endpoint_resource_id   = azurerm_private_endpoint.databricks.id
  }
}

resource "databricks_endpoint" "google" {
  parent       = "accounts/account"
  display_name = "google-service-direct"
  region       = "us-central1"

  gcp_psc_endpoint_info = {
    endpoint_region = "us-central1"
    project_id      = "rootform-project"
    psc_endpoint    = google_compute_forwarding_rule.databricks.name
  }
}

resource "databricks_metastore" "platform" {
  name         = "platform"
  region       = "us-east-1"
  storage_root = aws_s3_bucket.data.id
}

resource "databricks_metastore_assignment" "aws" {
  workspace_id = databricks_mws_workspaces.aws.workspace_id
  metastore_id = databricks_metastore.platform.id
}

resource "databricks_catalog" "analytics" {
  name         = "analytics"
  metastore_id = databricks_metastore.platform.id
  storage_root = aws_s3_bucket.data.id
}

resource "databricks_schema" "curated" {
  name         = "curated"
  catalog_name = databricks_catalog.analytics.name
}

resource "databricks_storage_credential" "aws" {
  name         = "aws-data"
  metastore_id = databricks_metastore.platform.id

  aws_iam_role {
    role_arn = aws_iam_role.databricks.arn
  }
}

resource "databricks_storage_credential" "azure" {
  name         = "azure-data"
  metastore_id = databricks_metastore.platform.id

  azure_managed_identity {
    access_connector_id = "/subscriptions/example/resourceGroups/rg/providers/Microsoft.Databricks/accessConnectors/rootform"
    managed_identity_id = azurerm_user_assigned_identity.databricks.id
  }
}

resource "databricks_storage_credential" "google" {
  name         = "google-data"
  metastore_id = databricks_metastore.platform.id

  gcp_service_account_key {
    email          = google_service_account.databricks.email
    private_key    = "ROOTFORM_DATABRICKS_GCP_PRIVATE_KEY"
    private_key_id = "rootform-key"
  }
}

resource "databricks_external_location" "aws" {
  name            = "aws-data"
  metastore_id    = databricks_metastore.platform.id
  credential_name = databricks_storage_credential.aws.name
  url             = aws_s3_bucket.data.id
}

resource "databricks_external_location" "azure" {
  name            = "azure-data"
  metastore_id    = databricks_metastore.platform.id
  credential_name = databricks_storage_credential.azure.name
  url             = azurerm_storage_container.data.id
}

resource "databricks_external_location" "google" {
  name            = "google-data"
  metastore_id    = databricks_metastore.platform.id
  credential_name = databricks_storage_credential.google.name
  url             = google_storage_bucket.data.id
}

resource "databricks_instance_pool" "shared" {
  instance_pool_name = "Shared"
  min_idle_instances = 0
  max_capacity       = 20
  node_type_id       = "i3.xlarge"
}

resource "databricks_cluster" "engineering" {
  cluster_name     = "Engineering"
  spark_version   = "17.3.x-scala2.12"
  instance_pool_id = databricks_instance_pool.shared.id
  num_workers      = 2

  aws_attributes {
    instance_profile_arn = aws_iam_role.databricks.arn
  }
}

resource "databricks_sql_endpoint" "analytics" {
  name                 = "Analytics"
  cluster_size         = "Small"
  max_num_clusters     = 2
  instance_profile_arn = aws_iam_role.databricks.arn
}

resource "databricks_pipeline" "orders" {
  name    = "Orders"
  catalog = databricks_catalog.analytics.name
  target  = databricks_schema.curated.name
}

resource "databricks_job" "daily" {
  name                = "Daily orders"
  existing_cluster_id = databricks_cluster.engineering.id
}

resource "databricks_app" "operations" {
  name = "operations"
}

resource "databricks_model_serving" "fraud" {
  name = "fraud-detection"
}

resource "databricks_vector_search_endpoint" "search" {
  name          = "search"
  endpoint_type = "STANDARD"
}

resource "databricks_vector_search_index" "documents" {
  name          = "analytics.curated.documents"
  endpoint_name = databricks_vector_search_endpoint.search.name
  primary_key   = "id"
  index_type    = "DELTA_SYNC"
}

resource "databricks_ai_search_endpoint" "search" {
  endpoint_id = "search"
  parent      = databricks_schema.curated.id
}

resource "databricks_ai_search_index" "documents" {
  index_id    = "documents"
  parent      = databricks_schema.curated.id
  endpoint    = databricks_ai_search_endpoint.search.name
  primary_key = "id"
  index_type  = "DELTA_SYNC"
}

resource "databricks_postgres_project" "application" {
  project_id = "application"
}

resource "databricks_postgres_branch" "production" {
  branch_id = "production"
  parent    = databricks_postgres_project.application.name
}

resource "databricks_postgres_endpoint" "primary" {
  endpoint_id = "primary"
  parent      = databricks_postgres_branch.production.name
}

resource "databricks_postgres_database" "application" {
  database_id = "application"
  parent      = databricks_postgres_branch.production.name
}

resource "databricks_postgres_data_api" "application" {
  parent = databricks_postgres_project.application.name
}

resource "databricks_quality_monitor_v2" "orders" {
  object_type = "table"
  object_id   = "analytics.curated.orders"
}
