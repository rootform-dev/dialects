terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.9.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "= 2.12.0"
    }
  }
}

resource "azurerm_linux_virtual_machine" "compute" {
  name = "compute"
}

resource "azurerm_container_app" "containers" {
  name = "containers"
}

resource "azurerm_linux_function_app" "serverless" {
  name = "serverless"
}

resource "azurerm_nat_gateway" "network" {
  name = "network"
}

resource "azurerm_cdn_frontdoor_profile" "load_balancing" {
  name = "load-balancing"
}

resource "azurerm_dns_zone" "dns" {
  name = "example.invalid"
}

resource "azurerm_storage_container" "storage" {
  name = "storage"
}

resource "azurerm_cosmosdb_account" "database" {
  name = "database"
}

resource "azurerm_data_factory" "analytics" {
  name = "analytics"
}

resource "azurerm_servicebus_namespace" "messaging" {
  name = "messaging"
}

resource "azurerm_ai_foundry" "ai" {
  name = "ai"
}

resource "azuread_group" "identity" {
  display_name = "identity"
}

resource "azurerm_key_vault" "security" {
  name = "security"
}

resource "azurerm_api_management" "api" {
  name = "api"
}

resource "azurerm_monitor_workspace" "operations" {
  name = "operations"
}

resource "azurerm_dev_center" "developer" {
  name = "developer"
}

resource "azurerm_arc_machine" "hybrid" {
  name = "hybrid"
}

resource "azurerm_database_migration_service" "migration" {
  name = "migration"
}

resource "azurerm_iothub" "iot" {
  name = "iot"
}

resource "azurerm_communication_service" "communication" {
  name = "communication"
}

resource "azurerm_management_group" "governance" {
  display_name = "governance"
}

resource "azapi_resource" "horizondb" {
  type      = "Microsoft.HorizonDb/clusters@2026-01-20-preview"
  name      = "horizondb"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}

resource "azapi_resource" "sre" {
  type      = "Microsoft.App/agents@2026-01-01"
  name      = "sre"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}

resource "azapi_resource" "enclave" {
  type      = "Microsoft.Mission/virtualEnclaves@2026-03-01-preview"
  name      = "enclave"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}
