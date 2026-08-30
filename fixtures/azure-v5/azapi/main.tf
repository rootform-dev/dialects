terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "= 2.12.0"
    }
  }
}

variable "dynamic_type" {
  type    = string
  default = "Microsoft.App/agents@2026-01-01"
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

resource "azapi_resource" "dynamic" {
  type      = var.dynamic_type
  name      = "dynamic"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}

resource "azapi_resource" "wrong_version" {
  type      = "Microsoft.App/agents@2026-02-01"
  name      = "wrong-version"
  parent_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic"
}
