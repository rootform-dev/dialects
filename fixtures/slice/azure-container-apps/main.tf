terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_id" { type = string }

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}
resource "azurerm_virtual_network" "platform" { name = "platform" }
resource "azurerm_subnet" "apps" { name = "apps" }
resource "azurerm_log_analytics_workspace" "platform" { name = "platform" }

resource "azurerm_container_app_environment" "platform" {
  name                       = "platform"
  resource_group_name        = azurerm_resource_group.platform.name
  location                   = azurerm_resource_group.platform.location
  infrastructure_subnet_id   = azurerm_subnet.apps.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.platform.id
}

resource "azurerm_container_app" "api" {
  name                         = "api"
  resource_group_name          = azurerm_resource_group.platform.name
  container_app_environment_id = azurerm_container_app_environment.platform.id
}

resource "azurerm_container_app_job" "worker" {
  name                         = "worker"
  resource_group_name          = azurerm_resource_group.platform.name
  container_app_environment_id = azurerm_container_app_environment.platform.id
}

resource "azurerm_container_app_environment" "literal" {
  name                       = "literal"
  resource_group_name        = "platform"
  location                   = azurerm_resource_group.platform.location
  infrastructure_subnet_id   = "/subscriptions/example/subnets/apps"
  log_analytics_workspace_id = "/subscriptions/example/workspaces/platform"
}

resource "azurerm_container_app" "unknown" {
  name                         = "unknown"
  resource_group_name          = var.unknown_id
  container_app_environment_id = var.unknown_id
}
