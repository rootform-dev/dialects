terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_resource_group" "identity" {
  name     = "identity"
  location = "West Europe"
}

resource "azurerm_user_assigned_identity" "workload" {
  name                = "workload"
  location            = azurerm_resource_group.identity.location
  resource_group_name = azurerm_resource_group.identity.name
}
