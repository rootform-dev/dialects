terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_virtual_network" "spoke" {
  name                = "spoke"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.spoke.name
}

resource "azurerm_subnet" "private_services" {
  name                 = "private-services"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.spoke.name
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = azurerm_resource_group.platform.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}

resource "azurerm_nat_gateway" "egress" {
  name                = "egress"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "vpn"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_express_route_circuit" "private" {
  name                = "private"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_kubernetes_cluster" "workloads" {
  name                = "workloads"
  resource_group_name = azurerm_resource_group.platform.name

  default_node_pool {
    name           = "system"
    vnet_subnet_id = azurerm_subnet.aks.id
  }
}

resource "azurerm_service_plan" "apps" {
  name                = "apps"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_linux_web_app" "api" {
  name                = "api"
  resource_group_name = azurerm_resource_group.platform.name
  service_plan_id     = azurerm_service_plan.apps.id
}

resource "azurerm_linux_function_app" "worker" {
  name                = "worker"
  resource_group_name = azurerm_resource_group.platform.name
  service_plan_id     = azurerm_service_plan.apps.id
}

resource "azurerm_mssql_server" "data" {
  name                = "data"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_mssql_database" "orders" {
  name      = "orders"
  server_id = azurerm_mssql_server.data.id
}

resource "azurerm_storage_account" "data" {
  name                = "rootformscenario"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_storage_container" "events" {
  name                 = "events"
  storage_account_name = azurerm_storage_account.data.name
}

resource "azurerm_private_endpoint" "sql" {
  name                = "sql"
  resource_group_name = azurerm_resource_group.platform.name
  subnet_id           = azurerm_subnet.private_services.id

  private_service_connection {
    name                           = "sql"
    private_connection_resource_id = azurerm_mssql_server.data.id
    is_manual_connection           = false
  }
}

resource "azurerm_private_endpoint" "storage" {
  name                = "storage"
  resource_group_name = azurerm_resource_group.platform.name
  subnet_id           = azurerm_subnet.private_services.id

  private_service_connection {
    name                           = "storage"
    private_connection_resource_id = azurerm_storage_account.data.id
    is_manual_connection           = false
  }
}

resource "azurerm_application_gateway" "ingress" {
  name                = "ingress"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_cdn_frontdoor_profile" "global" {
  name                = "global"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_servicebus_namespace" "bus" {
  name                = "bus"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_servicebus_queue" "commands" {
  name         = "commands"
  namespace_id = azurerm_servicebus_namespace.bus.id
}

resource "azurerm_servicebus_topic" "events" {
  name         = "events"
  namespace_id = azurerm_servicebus_namespace.bus.id
}

resource "azurerm_servicebus_subscription" "analytics" {
  name     = "analytics"
  topic_id = azurerm_servicebus_topic.events.id
}

resource "azurerm_eventhub_namespace" "streams" {
  name                = "streams"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_eventhub" "telemetry" {
  name         = "telemetry"
  namespace_id = azurerm_eventhub_namespace.streams.id
}

resource "azurerm_eventgrid_topic" "notifications" {
  name                = "notifications"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_user_assigned_identity" "workload" {
  name                = "workload"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_key_vault" "secrets" {
  name                = "secrets"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_key_vault_secret" "connection" {
  name         = "connection"
  value        = "synthetic-not-a-real-secret"
  key_vault_id = azurerm_key_vault.secrets.id
}

resource "azurerm_data_factory" "integration" {
  name                = "integration"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_synapse_workspace" "analytics" {
  name                = "analytics"
  resource_group_name = azurerm_resource_group.platform.name
}
