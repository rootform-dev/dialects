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
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.16.0"
    }
  }
}

resource "aws_vpc" "atlas" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.atlas.id
  cidr_block = "10.10.1.0/24"
}

resource "aws_vpc_endpoint" "atlas" {
  vpc_id       = aws_vpc.atlas.id
  service_name = "com.amazonaws.vpce.us-east-1.mongodb"
}

resource "aws_s3_bucket" "backups" {
  bucket = "rootform-atlas-backups"
}

resource "aws_s3_bucket" "federation" {
  bucket = "rootform-atlas-federation"
}

resource "aws_iam_role" "atlas" {
  name               = "rootform-atlas"
  assume_role_policy = "ROOTFORM_ATLAS_AWS_TRUST_SENTINEL"
}

resource "aws_kms_key" "atlas" {
  description = "Atlas database key"
}

resource "azurerm_resource_group" "atlas" {
  name     = "rg-atlas"
  location = "West Europe"
}

resource "azurerm_virtual_network" "atlas" {
  name                = "vnet-atlas"
  location            = azurerm_resource_group.atlas.location
  resource_group_name = azurerm_resource_group.atlas.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.atlas.name
  virtual_network_name = azurerm_virtual_network.atlas.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_private_endpoint" "atlas" {
  name                = "pe-atlas"
  location            = azurerm_resource_group.atlas.location
  resource_group_name = azurerm_resource_group.atlas.name
  subnet_id           = azurerm_subnet.private.id
}

resource "azurerm_storage_account" "atlas" {
  name                     = "rootformatlas"
  resource_group_name      = azurerm_resource_group.atlas.name
  location                 = azurerm_resource_group.atlas.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "federation" {
  name                  = "federation"
  storage_account_id    = azurerm_storage_account.atlas.id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "atlas" {
  name                = "id-atlas"
  resource_group_name = azurerm_resource_group.atlas.name
  location            = azurerm_resource_group.atlas.location
}

resource "azurerm_key_vault" "atlas" {
  name                = "kv-rootform-atlas"
  location            = azurerm_resource_group.atlas.location
  resource_group_name = azurerm_resource_group.atlas.name
  tenant_id           = "00000000-0000-0000-0000-000000000000"
  sku_name            = "standard"
}

resource "azurerm_key_vault_key" "atlas" {
  name         = "atlas"
  key_vault_id = azurerm_key_vault.atlas.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt"]
}

resource "google_compute_network" "atlas" {
  name                    = "atlas-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "atlas-private"
  network       = google_compute_network.atlas.id
  ip_cidr_range = "10.30.0.0/20"
  region        = "us-central1"
}

resource "google_compute_forwarding_rule" "atlas" {
  name                  = "atlas-psc"
  network               = google_compute_network.atlas.id
  subnetwork            = google_compute_subnetwork.private.id
  load_balancing_scheme = ""
}

resource "google_storage_bucket" "federation" {
  name     = "rootform-atlas-federation"
  location = "US"
}

resource "google_service_account" "atlas" {
  account_id   = "rootform-atlas"
  display_name = "MongoDB Atlas"
}

resource "google_kms_key_ring" "atlas" {
  name     = "atlas"
  location = "us-central1"
}

resource "google_kms_crypto_key" "atlas" {
  name     = "database"
  key_ring = google_kms_key_ring.atlas.id
}

resource "mongodbatlas_organization" "platform" {
  name = "Rootform"
}

resource "mongodbatlas_project" "application" {
  name   = "application"
  org_id = mongodbatlas_organization.platform.id
}

resource "mongodbatlas_advanced_cluster" "primary" {
  project_id = mongodbatlas_project.application.id
  name       = "primary"
}

resource "mongodbatlas_cluster" "legacy" {
  project_id = mongodbatlas_project.application.id
  name       = "legacy"
}

resource "mongodbatlas_flex_cluster" "development" {
  project_id = mongodbatlas_project.application.id
  name       = "development"
}

resource "mongodbatlas_serverless_instance" "events" {
  project_id = mongodbatlas_project.application.id
  name       = "events"
}

resource "mongodbatlas_global_cluster_config" "primary" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
}

resource "mongodbatlas_maintenance_window" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_network_container" "atlas" {
  project_id = mongodbatlas_project.application.id
  atlas_cidr_block = "10.40.0.0/16"
}

resource "mongodbatlas_network_peering" "aws" {
  project_id   = mongodbatlas_project.application.id
  container_id = mongodbatlas_network_container.atlas.id
  vpc_id       = aws_vpc.atlas.id
}

resource "mongodbatlas_network_peering" "azure" {
  project_id   = mongodbatlas_project.application.id
  container_id = mongodbatlas_network_container.atlas.id
  vnet_name    = azurerm_virtual_network.atlas.name
}

resource "mongodbatlas_network_peering" "google" {
  project_id   = mongodbatlas_project.application.id
  container_id = mongodbatlas_network_container.atlas.id
  network_name = google_compute_network.atlas.name
}

resource "mongodbatlas_privatelink_endpoint" "aws" {
  project_id    = mongodbatlas_project.application.id
  provider_name = "AWS"
  region        = "US_EAST_1"
}

resource "mongodbatlas_privatelink_endpoint" "azure" {
  project_id    = mongodbatlas_project.application.id
  provider_name = "AZURE"
  region        = "EUROPE_WEST"
}

resource "mongodbatlas_privatelink_endpoint" "google" {
  project_id    = mongodbatlas_project.application.id
  provider_name = "GCP"
  region        = "CENTRAL_US"
}

resource "mongodbatlas_privatelink_endpoint_service" "aws" {
  project_id          = mongodbatlas_project.application.id
  private_link_id     = mongodbatlas_privatelink_endpoint.aws.id
  endpoint_service_id = aws_vpc_endpoint.atlas.id
}

resource "mongodbatlas_privatelink_endpoint_service" "azure" {
  project_id          = mongodbatlas_project.application.id
  private_link_id     = mongodbatlas_privatelink_endpoint.azure.id
  endpoint_service_id = azurerm_private_endpoint.atlas.id
}

resource "mongodbatlas_privatelink_endpoint_service" "google" {
  project_id          = mongodbatlas_project.application.id
  private_link_id     = mongodbatlas_privatelink_endpoint.google.id
  endpoint_service_id = google_compute_forwarding_rule.atlas.id
}

resource "mongodbatlas_privatelink_endpoint_service_data_federation_online_archive" "google" {
  project_id  = mongodbatlas_project.application.id
  endpoint_id = google_compute_forwarding_rule.atlas.id
}

resource "mongodbatlas_private_endpoint_regional_mode" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_project_ip_access_list" "office" {
  project_id = mongodbatlas_project.application.id
  cidr_block = "192.0.2.0/24"
}

resource "mongodbatlas_custom_dns_configuration_cluster_aws" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_cloud_provider_access_setup" "aws" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_cloud_provider_access_setup" "azure" {
  project_id = mongodbatlas_project.application.id

  azure_config {
    service_principal_id = azurerm_user_assigned_identity.atlas.client_id
  }
}

resource "mongodbatlas_cloud_provider_access_setup" "google" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_cloud_provider_access_authorization" "aws" {
  project_id = mongodbatlas_project.application.id
  role_id    = mongodbatlas_cloud_provider_access_setup.aws.id

  aws {
    iam_assumed_role_arn = aws_iam_role.atlas.arn
  }
}

resource "mongodbatlas_cloud_provider_access_authorization" "azure" {
  project_id = mongodbatlas_project.application.id
  role_id    = mongodbatlas_cloud_provider_access_setup.azure.id

  azure {
    service_principal_id = azurerm_user_assigned_identity.atlas.client_id
  }
}

resource "mongodbatlas_cloud_provider_access_authorization" "google" {
  project_id = mongodbatlas_project.application.id
  role_id    = mongodbatlas_cloud_provider_access_setup.google.id
}

resource "mongodbatlas_encryption_at_rest" "application" {
  project_id = mongodbatlas_project.application.id

  aws_kms_config {
    customer_master_key_id = aws_kms_key.atlas.id
    role_id                = mongodbatlas_cloud_provider_access_authorization.aws.role_id
  }

  azure_key_vault_config {
    key_identifier = azurerm_key_vault_key.atlas.id
    role_id        = mongodbatlas_cloud_provider_access_authorization.azure.role_id
  }

  google_cloud_kms_config {
    key_version_resource_id = google_kms_crypto_key.atlas.id
    role_id                 = mongodbatlas_cloud_provider_access_authorization.google.role_id
  }
}

resource "mongodbatlas_encryption_at_rest_private_endpoint" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_auditing" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_cloud_backup_snapshot_export_bucket" "aws" {
  project_id  = mongodbatlas_project.application.id
  bucket_name = aws_s3_bucket.backups.id
  iam_role_id = mongodbatlas_cloud_provider_access_authorization.aws.role_id
}

resource "mongodbatlas_cloud_backup_schedule" "primary" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name

  export {
    export_bucket_id = mongodbatlas_cloud_backup_snapshot_export_bucket.aws.id
  }
}

resource "mongodbatlas_backup_compliance_policy" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_federated_database_instance" "aws" {
  project_id = mongodbatlas_project.application.id
  name       = "aws-federation"

  storage_stores {
    bucket       = aws_s3_bucket.federation.id
    cluster_name = mongodbatlas_advanced_cluster.primary.name
  }

  cloud_provider_config {
    aws {
      role_id = mongodbatlas_cloud_provider_access_authorization.aws.role_id
    }
  }
}

resource "mongodbatlas_federated_database_instance" "azure" {
  project_id = mongodbatlas_project.application.id
  name       = "azure-federation"

  storage_stores {
    bucket = azurerm_storage_container.federation.name
  }

  cloud_provider_config {
    azure {
      role_id = mongodbatlas_cloud_provider_access_authorization.azure.role_id
    }
  }
}

resource "mongodbatlas_federated_database_instance" "google" {
  project_id = mongodbatlas_project.application.id
  name       = "google-federation"

  storage_stores {
    bucket = google_storage_bucket.federation.name
  }
}

resource "mongodbatlas_online_archive" "orders" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
}

resource "mongodbatlas_federated_query_limit" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_search_deployment" "primary" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
}

resource "mongodbatlas_search_index" "documents" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
  name         = "documents"
}

resource "mongodbatlas_ai_model_rate_limit" "application" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_stream_workspace" "analytics" {
  project_id = mongodbatlas_project.application.id
  name       = "analytics"
}

resource "mongodbatlas_stream_instance" "legacy" {
  project_id = mongodbatlas_project.application.id
  instance_name = "legacy-streams"
}

resource "mongodbatlas_stream_privatelink_endpoint" "aws" {
  project_id          = mongodbatlas_project.application.id
  service_endpoint_id = aws_vpc.atlas.id
}

resource "mongodbatlas_stream_connection" "events" {
  project_id     = mongodbatlas_project.application.id
  workspace_name = mongodbatlas_stream_workspace.analytics.name
  connection_name = "events"
  cluster_name    = mongodbatlas_advanced_cluster.primary.name

  aws {
    role_arn = aws_iam_role.atlas.arn
  }

  azure {
    service_principal_id = azurerm_user_assigned_identity.atlas.client_id
  }

  gcp {
    service_account_id = google_service_account.atlas.id
  }

  networking {
    access {
      connection_id = mongodbatlas_stream_privatelink_endpoint.aws.id
    }
  }
}

resource "mongodbatlas_stream_connection_failover" "events" {
  project_id      = mongodbatlas_project.application.id
  connection_name = mongodbatlas_stream_connection.events.connection_name
}

resource "mongodbatlas_stream_processor" "orders" {
  project_id     = mongodbatlas_project.application.id
  workspace_name = mongodbatlas_stream_workspace.analytics.name
  name           = "orders"
  pipeline       = "ROOTFORM_ATLAS_PIPELINE_SECRET"
}

resource "mongodbatlas_project_service_account" "automation" {
  project_id = mongodbatlas_project.application.id
  name       = "automation"
}

resource "mongodbatlas_service_account" "platform" {
  org_id = mongodbatlas_organization.platform.id
  name   = "platform"
}

resource "mongodbatlas_team" "platform" {
  org_id   = mongodbatlas_organization.platform.id
  name     = "platform"
  usernames = ["platform@example.com"]
}

resource "mongodbatlas_team_project_assignment" "platform" {
  project_id = mongodbatlas_project.application.id
  team_id    = mongodbatlas_team.platform.id
  role_names = ["GROUP_OWNER"]
}

resource "mongodbatlas_service_account_project_assignment" "platform" {
  project_id = mongodbatlas_project.application.id
  client_id  = mongodbatlas_service_account.platform.client_id
  roles      = ["GROUP_READ_ONLY"]
}

resource "mongodbatlas_federated_settings_identity_provider" "workforce" {
  name = "workforce"
}

resource "mongodbatlas_log_integration" "archive" {
  project_id             = mongodbatlas_project.application.id
  bucket_name            = aws_s3_bucket.backups.id
  storage_container_name = azurerm_storage_container.federation.name
  kms_key                = aws_kms_key.atlas.id
  iam_role_id            = mongodbatlas_cloud_provider_access_authorization.aws.role_id
}

resource "mongodbatlas_push_based_log_export" "archive" {
  project_id  = mongodbatlas_project.application.id
  bucket_name = aws_s3_bucket.backups.id
  iam_role_id = mongodbatlas_cloud_provider_access_authorization.aws.role_id
}

resource "mongodbatlas_metric_integration" "monitoring" {
  for_each   = toset(["eu", "us"])
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_alert_configuration" "database" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_third_party_integration" "incident" {
  project_id = mongodbatlas_project.application.id
  api_key    = "ROOTFORM_ATLAS_OBSERVABILITY_SECRET"
}

resource "mongodbatlas_event_trigger" "orders" {
  project_id = mongodbatlas_project.application.id
  name       = "orders"
}
