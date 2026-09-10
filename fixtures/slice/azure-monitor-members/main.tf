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

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "PerGB2018"
}

resource "azurerm_storage_account" "archive" {
  name                     = "rootformarchive"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_solution" "containers" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.platform.name
  location              = azurerm_resource_group.platform.location
  workspace_resource_id = azurerm_log_analytics_workspace.platform.id
  workspace_name        = azurerm_log_analytics_workspace.platform.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_log_analytics_saved_search" "failed_requests" {
  name                       = "failed-requests"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.platform.id
  category                   = "platform"
  display_name               = "Failed requests"
  query                      = "AppRequests | where Success == false"
}

resource "azurerm_log_analytics_data_export_rule" "archive" {
  name                    = "archive"
  resource_group_name     = azurerm_resource_group.platform.name
  workspace_resource_id   = azurerm_log_analytics_workspace.platform.id
  destination_resource_id = azurerm_storage_account.archive.id
  table_names             = ["AppRequests"]
}

resource "azurerm_log_analytics_workspace_table" "requests" {
  name                    = "AppRequests"
  workspace_id            = azurerm_log_analytics_workspace.platform.id
  retention_in_days       = 30
  total_retention_in_days = 90
}

# literal and unknown workspace references produce no contribution
resource "azurerm_log_analytics_solution" "literal" {
  solution_name         = "SecurityInsights"
  resource_group_name   = azurerm_resource_group.platform.name
  location              = azurerm_resource_group.platform.location
  workspace_resource_id = "/subscriptions/example/workspaces/platform"
  workspace_name        = "platform"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

resource "azurerm_log_analytics_saved_search" "unknown" {
  name                       = "unknown"
  log_analytics_workspace_id = var.unknown_id
  category                   = "platform"
  display_name               = "Unknown"
  query                      = "Heartbeat"
}
