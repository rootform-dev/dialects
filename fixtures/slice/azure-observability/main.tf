terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_value" { type = string }

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

resource "azurerm_virtual_network" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.70.0.0/16"]
}

resource "azurerm_subnet" "apps" {
  name                 = "apps"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.70.1.0/24"]
}

resource "azurerm_service_plan" "apps" {
  name                = "apps"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "platform" {
  name                = "platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.platform.id
}

resource "azurerm_application_insights" "classic" {
  name                = "classic"
  resource_group_name = "platform"
  location            = azurerm_resource_group.platform.location
  application_type    = "web"
}

resource "azurerm_linux_web_app" "linux" {
  name                      = "linux"
  resource_group_name       = azurerm_resource_group.platform.name
  location                  = azurerm_resource_group.platform.location
  service_plan_id           = azurerm_service_plan.apps.id
  virtual_network_subnet_id = azurerm_subnet.apps.id
  site_config { application_insights_connection_string = azurerm_application_insights.platform.connection_string }
}

resource "azurerm_windows_web_app" "windows" {
  name                      = "windows"
  resource_group_name       = azurerm_resource_group.platform.name
  location                  = azurerm_resource_group.platform.location
  service_plan_id           = azurerm_service_plan.apps.id
  virtual_network_subnet_id = azurerm_subnet.apps.id
  site_config { application_insights_connection_string = azurerm_application_insights.platform.connection_string }
}

resource "azurerm_linux_function_app" "linux" {
  name                       = "linux-function"
  resource_group_name        = azurerm_resource_group.platform.name
  location                   = azurerm_resource_group.platform.location
  service_plan_id            = azurerm_service_plan.apps.id
  virtual_network_subnet_id  = azurerm_subnet.apps.id
  storage_account_name       = "fixture"
  storage_account_access_key = "ROOTFORM_AZURE_STORAGE_KEY_SENTINEL"
  site_config { application_insights_connection_string = azurerm_application_insights.platform.connection_string }
}

resource "azurerm_windows_function_app" "windows" {
  name                       = "windows-function"
  resource_group_name        = azurerm_resource_group.platform.name
  location                   = azurerm_resource_group.platform.location
  service_plan_id            = azurerm_service_plan.apps.id
  virtual_network_subnet_id  = azurerm_subnet.apps.id
  storage_account_name       = "fixture"
  storage_account_access_key = "ROOTFORM_AZURE_STORAGE_KEY_SENTINEL"
  site_config { application_insights_connection_string = azurerm_application_insights.platform.connection_string }
}

resource "azurerm_linux_web_app" "literal" {
  name                      = "literal"
  resource_group_name       = "platform"
  location                  = azurerm_resource_group.platform.location
  service_plan_id           = "/subscriptions/example/plans/apps"
  virtual_network_subnet_id = "/subscriptions/example/subnets/apps"
  site_config { application_insights_connection_string = "InstrumentationKey=literal" }
}

resource "azurerm_linux_web_app" "unknown" {
  name                      = "unknown"
  resource_group_name       = var.unknown_value
  location                  = azurerm_resource_group.platform.location
  service_plan_id           = var.unknown_value
  virtual_network_subnet_id = var.unknown_value
  site_config { application_insights_connection_string = var.unknown_value }
}
