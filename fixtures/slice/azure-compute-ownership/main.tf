terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_group" { type = string }

resource "azurerm_resource_group" "compute" {
  name     = "compute"
  location = "West Europe"
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                = "linux"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_windows_virtual_machine" "windows" {
  name                = "windows"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_virtual_machine" "legacy" {
  name                = "legacy"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_linux_virtual_machine_scale_set" "linux" {
  name                = "linux"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_windows_virtual_machine_scale_set" "windows" {
  name                = "windows"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_virtual_machine_scale_set" "legacy" {
  name                = "legacy"
  resource_group_name = azurerm_resource_group.compute.name
}
resource "azurerm_linux_virtual_machine" "literal" {
  name                = "literal"
  resource_group_name = "compute"
}
resource "azurerm_linux_virtual_machine" "unknown" {
  name                = "unknown"
  resource_group_name = var.unknown_group
}
