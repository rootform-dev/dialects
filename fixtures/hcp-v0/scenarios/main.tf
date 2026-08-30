terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    confluent = {
      source = "confluentinc/confluent"
    }
    google = {
      source = "hashicorp/google"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.114.0"
    }
  }
}

resource "hcp_project" "platform" {
  name = "rootform-platform"
}

data "hcp_organization" "current" {}

resource "hcp_project_iam_binding" "automation" {
  project_id   = hcp_project.platform.resource_id
  principal_id = hcp_service_principal.automation.resource_id
  role         = "roles/contributor"
}

resource "hcp_resource_control_policy" "products" {
  organization_id    = data.hcp_organization.current.resource_id
  enabled_constraints = ["hcp.disable_product.consul"]
}

resource "aws_vpc" "applications" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_iam_role" "vault" {
  name = "rootform-hcp-vault"
}

resource "azurerm_resource_group" "applications" {
  name     = "rootform-hcp"
  location = "West US 2"
}

resource "azurerm_virtual_network" "applications" {
  name                = "rootform-hcp"
  location            = azurerm_resource_group.applications.location
  resource_group_name = azurerm_resource_group.applications.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_user_assigned_identity" "vault" {
  name                = "rootform-hcp-vault"
  location            = azurerm_resource_group.applications.location
  resource_group_name = azurerm_resource_group.applications.name
}

resource "google_service_account" "vault" {
  account_id = "rootform-hcp-vault"
}

resource "confluent_service_account" "vault" {
  display_name = "rootform-hcp-vault"
  description  = "Synthetic HCP fixture identity"
}

resource "hcp_service_principal" "automation" {
  name = "rootform-automation"
}

resource "hcp_group" "platform" {
  display_name = "Rootform platform"
}

resource "hcp_group_members" "platform" {
  group   = hcp_group.platform.resource_name
  members = [hcp_service_principal.automation.resource_name]
}

resource "hcp_group_iam_binding" "platform" {
  name         = hcp_group.platform.resource_name
  principal_id = hcp_service_principal.automation.resource_id
  role         = "roles/viewer"
}

resource "hcp_iam_workload_identity_provider" "aws" {
  name              = "rootform-aws"
  service_principal = hcp_service_principal.automation.resource_name
  conditional_access = "aws.arn matches `^arn:aws:sts::123456789012:assumed-role/rootform`"
  aws = {
    account_id = "123456789012"
  }
}

resource "hcp_hvn" "aws" {
  hvn_id         = "rootform-aws"
  cloud_provider = "aws"
  region         = "us-west-2"
  cidr_block     = "172.25.16.0/20"
  project_id     = hcp_project.platform.resource_id
}

resource "hcp_hvn" "azure" {
  hvn_id         = "rootform-azure"
  cloud_provider = "azure"
  region         = "westus2"
  cidr_block     = "172.26.16.0/20"
  project_id     = hcp_project.platform.resource_id
}

resource "hcp_aws_network_peering" "applications" {
  hvn_id          = hcp_hvn.aws.hvn_id
  peering_id      = "rootform-applications"
  peer_vpc_id     = aws_vpc.applications.id
  peer_account_id = "123456789012"
  peer_vpc_region = "us-west-2"
  project_id      = hcp_project.platform.resource_id
}

resource "hcp_azure_peering_connection" "applications" {
  hvn_link                 = hcp_hvn.azure.self_link
  peering_id               = "rootform-applications"
  peer_vnet_name           = azurerm_virtual_network.applications.name
  peer_subscription_id     = "00000000-0000-0000-0000-000000000001"
  peer_tenant_id           = "00000000-0000-0000-0000-000000000002"
  peer_resource_group_name = azurerm_resource_group.applications.name
  peer_vnet_region         = azurerm_virtual_network.applications.location
}

resource "hcp_hvn_peering_connection" "clouds" {
  hvn_1 = hcp_hvn.aws.self_link
  hvn_2 = hcp_hvn.azure.self_link
}

resource "hcp_aws_transit_gateway_attachment" "shared" {
  hvn_id                        = hcp_hvn.aws.hvn_id
  transit_gateway_attachment_id = "rootform-shared"
  transit_gateway_id            = "tgw-0123456789abcdef0"
  resource_share_arn            = "arn:aws:ram:us-west-2:123456789012:resource-share/rootform"
  project_id                    = hcp_project.platform.resource_id
}

resource "hcp_hvn_route" "applications" {
  hvn_link         = hcp_hvn.aws.self_link
  hvn_route_id     = "rootform-applications"
  destination_cidr = aws_vpc.applications.cidr_block
  target_link      = hcp_aws_network_peering.applications.self_link
  project_id       = hcp_project.platform.resource_id
}

resource "hcp_dns_forwarding" "applications" {
  dns_forwarding_id = "rootform-applications"
  hvn_id             = hcp_hvn.aws.hvn_id
  connection_type    = "hvn-peering"
  peering_id         = hcp_aws_network_peering.applications.peering_id
  project_id         = hcp_project.platform.resource_id
}

resource "hcp_dns_forwarding_rule" "internal" {
  dns_forwarding_id  = hcp_dns_forwarding.applications.dns_forwarding_id
  hvn_id              = hcp_hvn.aws.hvn_id
  rule_id             = "rootform-internal"
  domain_name         = "internal.rootform.invalid"
  inbound_endpoint_ips = ["10.10.0.10"]
  project_id          = hcp_project.platform.resource_id
}

resource "hcp_vault_cluster" "security" {
  cluster_id = "rootform-security"
  hvn_id     = hcp_hvn.aws.hvn_id
  project_id = hcp_project.platform.resource_id
}

resource "hcp_vault_plugin" "transform" {
  cluster_id  = hcp_vault_cluster.security.cluster_id
  plugin_name = "rootform-transform"
  plugin_type = "secret"
  project_id  = hcp_project.platform.resource_id
}

resource "hcp_private_link" "vault" {
  private_link_id  = "rootform-vault"
  hvn_id           = hcp_hvn.aws.hvn_id
  vault_cluster_id = hcp_vault_cluster.security.cluster_id
  project_id       = hcp_project.platform.resource_id
}

resource "hcp_boundary_cluster" "access" {
  cluster_id = "rootform-access"
  tier       = "standard"
  username   = "rootform-admin"
  password   = "ROOTFORM_HCP_BOUNDARY_PASSWORD_SENTINEL"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_consul_cluster" "legacy" {
  cluster_id = "rootform-legacy"
  hvn_id     = hcp_hvn.aws.hvn_id
  tier       = "development"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_consul_snapshot" "legacy" {
  cluster_id    = hcp_consul_cluster.legacy.cluster_id
  snapshot_name = "rootform-legacy"
  project_id    = hcp_project.platform.resource_id
}

resource "hcp_packer_bucket" "base" {
  name       = "rootform-base"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_packer_channel" "production" {
  bucket_name = hcp_packer_bucket.base.name
  name        = "production"
  project_id  = hcp_project.platform.resource_id
}

data "hcp_packer_version" "base" {
  bucket_name  = hcp_packer_bucket.base.name
  channel_name = hcp_packer_channel.production.name
  project_id   = hcp_project.platform.resource_id
}

data "hcp_packer_artifact" "aws" {
  bucket_name        = hcp_packer_bucket.base.name
  version_fingerprint = data.hcp_packer_version.base.fingerprint
  platform           = "aws"
  region             = "us-west-2"
  project_id         = hcp_project.platform.resource_id
}

resource "hcp_packer_channel_assignment" "production" {
  bucket_name        = hcp_packer_bucket.base.name
  channel_name       = hcp_packer_channel.production.name
  version_fingerprint = data.hcp_packer_version.base.fingerprint
  project_id         = hcp_project.platform.resource_id
}

resource "hcp_waypoint_template" "service" {
  name                            = "rootform-service"
  summary                         = "Rootform service pattern"
  terraform_no_code_module_id     = "nocode-rootform-service"
  terraform_no_code_module_source = "app.terraform.io/rootform/service/aws"
  terraform_project_id            = "project-rootform"
  project_id                      = hcp_project.platform.resource_id
}

resource "hcp_waypoint_application" "api" {
  name        = "rootform-api"
  template_id = hcp_waypoint_template.service.id
  project_id  = hcp_project.platform.resource_id
}

resource "hcp_waypoint_add_on_definition" "database" {
  name                            = "rootform-database"
  description                     = "Managed database add-on"
  summary                         = "Database"
  terraform_no_code_module_id     = "nocode-rootform-database"
  terraform_no_code_module_source = "app.terraform.io/rootform/database/aws"
  terraform_project_id            = "project-rootform"
  project_id                      = hcp_project.platform.resource_id
}

resource "hcp_waypoint_add_on" "database" {
  name           = "rootform-database"
  application_id = hcp_waypoint_application.api.id
  definition_id  = hcp_waypoint_add_on_definition.database.id
  project_id     = hcp_project.platform.resource_id
}

resource "hcp_waypoint_agent_group" "platform" {
  name       = "rootform-platform"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_waypoint_action" "restart" {
  name       = "rootform-restart"
  project_id = hcp_project.platform.resource_id
  request = {
    custom = {
      method = "POST"
      url    = "https://actions.rootform.invalid/restart"
    }
  }
}

resource "hcp_waypoint_tfc_config" "platform" {
  tfc_org_name = "rootform"
  token        = "ROOTFORM_HCP_TFC_TOKEN_SENTINEL"
  project_id   = hcp_project.platform.resource_id
}

resource "hcp_vault_secrets_app" "api" {
  app_name   = "rootform-api"
  sync_names = [hcp_vault_secrets_sync.gitlab.name]
  project_id = hcp_project.platform.resource_id
}

resource "hcp_vault_secrets_integration" "aws" {
  name          = "rootform-aws"
  provider_type = "aws"
  capabilities  = ["DYNAMIC", "ROTATION"]
  project_id    = hcp_project.platform.resource_id
  aws_federated_workload_identity = {
    audience = "rootform"
    role_arn = aws_iam_role.vault.arn
  }
}

resource "hcp_vault_secrets_integration" "azure" {
  name          = "rootform-azure"
  provider_type = "azure"
  capabilities  = ["ROTATION"]
  project_id    = hcp_project.platform.resource_id
  azure_federated_workload_identity = {
    audience  = "rootform"
    client_id = azurerm_user_assigned_identity.vault.client_id
    tenant_id = "00000000-0000-0000-0000-000000000002"
  }
}

resource "hcp_vault_secrets_integration" "google" {
  name          = "rootform-google"
  provider_type = "gcp"
  capabilities  = ["DYNAMIC", "ROTATION"]
  project_id    = hcp_project.platform.resource_id
  gcp_federated_workload_identity = {
    audience              = "rootform"
    service_account_email = google_service_account.vault.email
  }
}

resource "hcp_vault_secrets_integration_confluent" "confluent" {
  name         = "rootform-confluent"
  capabilities = ["ROTATION"]
  project_id   = hcp_project.platform.resource_id
  static_credential_details = {
    cloud_api_key_id = "rootform-key"
    cloud_api_secret = "ROOTFORM_HCP_CONFLUENT_SECRET_SENTINEL"
  }
}

resource "hcp_vault_secrets_dynamic_secret" "aws" {
  app_name         = hcp_vault_secrets_app.api.app_name
  name             = "rootform-aws"
  secret_provider  = "aws"
  integration_name = hcp_vault_secrets_integration.aws.name
  project_id       = hcp_project.platform.resource_id
  aws_assume_role = {
    iam_role_arn = aws_iam_role.vault.arn
  }
}

resource "hcp_vault_secrets_rotating_secret" "google" {
  app_name            = hcp_vault_secrets_app.api.app_name
  name                = "rootform-google"
  secret_provider     = "gcp"
  integration_name    = hcp_vault_secrets_integration.google.name
  rotation_policy_name = "built-in:60-days-2-active"
  project_id          = hcp_project.platform.resource_id
  gcp_service_account_key = {
    service_account_email = google_service_account.vault.email
  }
}

resource "hcp_vault_secrets_rotating_secret" "confluent" {
  app_name            = hcp_vault_secrets_app.api.app_name
  name                = "rootform-confluent"
  secret_provider     = "confluent"
  integration_name    = hcp_vault_secrets_integration_confluent.confluent.name
  rotation_policy_name = "built-in:60-days-2-active"
  project_id          = hcp_project.platform.resource_id
  confluent_service_account = {
    service_account_id = confluent_service_account.vault.id
  }
}

resource "hcp_vault_secrets_secret" "api" {
  app_name    = hcp_vault_secrets_app.api.app_name
  secret_name = "api-key"
  secret_value = "ROOTFORM_HCP_VAULT_SECRET_SENTINEL"
  project_id  = hcp_project.platform.resource_id
}

resource "hcp_vault_secrets_sync" "gitlab" {
  name             = "rootform-gitlab"
  integration_name = hcp_vault_secrets_integration.aws.name
  project_id       = hcp_project.platform.resource_id
  gitlab_config = {
    group_id = "rootform"
    scope    = "group"
  }
}

resource "hcp_vault_secrets_app_iam_binding" "reader" {
  resource_name = hcp_vault_secrets_app.api.resource_name
  principal_id  = hcp_service_principal.automation.resource_id
  role          = "roles/secrets.app-secret-reader"
}

resource "hcp_vault_radar_source_github_cloud" "source" {
  github_organization = "rootform-dev"
  token               = "ROOTFORM_HCP_RADAR_GITHUB_TOKEN_SENTINEL"
  project_id          = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_source_github_enterprise" "source" {
  domain_name        = "github.rootform.invalid"
  github_organization = "rootform"
  token              = "ROOTFORM_HCP_RADAR_GHE_TOKEN_SENTINEL"
  project_id         = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_integration_jira_connection" "security" {
  name       = "rootform-security"
  base_url   = "https://jira.rootform.invalid"
  email      = "security@rootform.invalid"
  token      = "ROOTFORM_HCP_RADAR_JIRA_TOKEN_SENTINEL"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_integration_jira_subscription" "security" {
  name             = "rootform-security"
  connection_id    = hcp_vault_radar_integration_jira_connection.security.id
  issue_type       = "Task"
  jira_project_key = "SEC"
  project_id       = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_integration_slack_connection" "security" {
  name       = "rootform-security"
  token      = "ROOTFORM_HCP_RADAR_SLACK_TOKEN_SENTINEL"
  project_id = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_integration_slack_subscription" "security" {
  name          = "rootform-security"
  connection_id = hcp_vault_radar_integration_slack_connection.security.id
  channel       = "security"
  project_id    = hcp_project.platform.resource_id
}

resource "hcp_vault_radar_secret_manager_vault_dedicated" "security" {
  vault_url  = hcp_vault_cluster.security.vault_private_endpoint_url
  project_id = hcp_project.platform.resource_id
  token = {
    token_env_var = "ROOTFORM_HCP_RADAR_VAULT_TOKEN"
  }
}

resource "hcp_vault_radar_resource_iam_binding" "viewer" {
  resource_name = "radar/project/rootform/source/github"
  principal_id  = hcp_service_principal.automation.resource_id
  role          = "roles/viewer"
}

resource "hcp_log_streaming_destination" "cloudwatch" {
  name = "rootform-cloudwatch"
  cloudwatch = {
    external_id    = "ROOTFORM_HCP_LOG_EXTERNAL_ID_SENTINEL"
    region         = "us-west-2"
    role_arn       = aws_iam_role.vault.arn
    log_group_name = "rootform-hcp"
  }
}

resource "hcp_notifications_webhook" "lifecycle" {
  name       = "rootform-lifecycle"
  project_id = hcp_project.platform.resource_id
  config = {
    hmac_key = "ROOTFORM_HCP_WEBHOOK_HMAC_SENTINEL"
    url      = "https://events.rootform.invalid/hcp"
  }
  subscriptions = [{
    events      = ["resource.created"]
    resource_id = hcp_vault_cluster.security.id
  }]
}
