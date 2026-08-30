terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "= 2.12.0"
    }
  }
}

resource "azapi_resource" "sre" {
  type      = "Microsoft.App/agents@2026-01-01"
  name      = "sre"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
  body = {
    properties = {
      incidentManagementConfiguration = {
        connectionKey = "rootform-secret-sentinel"
      }
    }
  }
}
