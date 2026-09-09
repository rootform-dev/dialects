terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

variable "unknown_workspace_id" { type = string }

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "PerGB2018"
}

resource "azurerm_kubernetes_cluster" "workloads" {
  name                = "workloads"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = "workloads"

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_D2s_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.platform.id
  }
}

resource "azurerm_kubernetes_cluster" "literal_workspace" {
  name                = "literal-workspace"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = "literal"
  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }
  identity { type = "SystemAssigned" }
  oms_agent { log_analytics_workspace_id = "/subscriptions/example/resourceGroups/platform/providers/Microsoft.OperationalInsights/workspaces/platform" }
}

resource "azurerm_kubernetes_cluster" "unknown_workspace" {
  name                = "unknown-workspace"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = "unknown"
  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }
  identity { type = "SystemAssigned" }
  oms_agent { log_analytics_workspace_id = var.unknown_workspace_id }
}
