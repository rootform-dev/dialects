terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "= 2.12.0"
    }
  }
}

resource "azurerm_container_app" "typed" {
  name = "typed"
}

resource "azapi_resource" "unapproved_overlap" {
  type      = "Microsoft.App/containerApps@2025-01-01"
  name      = "unapproved-overlap"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}

resource "azapi_update_resource" "patch" {
  type        = "Microsoft.App/containerApps@2025-01-01"
  resource_id = azapi_resource.unapproved_overlap.id
}
