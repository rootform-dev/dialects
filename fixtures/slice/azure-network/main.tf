terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_resource_group" "network" {
  name     = "network"
  location = "West Europe"
}

resource "azurerm_virtual_network" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "workloads" {
  name                 = "workloads"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.20.1.0/24"]
}
