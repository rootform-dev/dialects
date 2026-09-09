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

resource "azurerm_cosmosdb_account" "platform" {
  name                = "rootform-platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  offer_type          = "Standard"
}

resource "azurerm_cosmosdb_sql_database" "catalog" {
  name                = "catalog"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
}

resource "azurerm_cosmosdb_sql_container" "products" {
  name                = "products"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
  database_name       = azurerm_cosmosdb_sql_database.catalog.name
  partition_key_paths = ["/sku"]
}

resource "azurerm_cosmosdb_mongo_database" "profiles" {
  name                = "profiles"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
}

resource "azurerm_cosmosdb_mongo_collection" "customers" {
  name                = "customers"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
  database_name       = azurerm_cosmosdb_mongo_database.profiles.name
}

resource "azurerm_cosmosdb_gremlin_database" "graph" {
  name                = "graph"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
}

resource "azurerm_cosmosdb_gremlin_graph" "recommendations" {
  name                = "recommendations"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
  database_name       = azurerm_cosmosdb_gremlin_database.graph.name
  partition_key_path  = "/customer"
}

resource "azurerm_cosmosdb_cassandra_keyspace" "events" {
  name                = "events"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
}

resource "azurerm_cosmosdb_cassandra_table" "clicks" {
  name                  = "clicks"
  cassandra_keyspace_id = azurerm_cosmosdb_cassandra_keyspace.events.id

  schema {
    column {
      name = "id"
      type = "text"
    }

    partition_key {
      name = "id"
    }
  }
}

resource "azurerm_cosmosdb_sql_dedicated_gateway" "platform" {
  cosmosdb_account_id = azurerm_cosmosdb_account.platform.id
  instance_count      = 1
  instance_size       = "Cosmos.D4s"
}

# literal and unknown parent references produce no ownership context or contribution
resource "azurerm_cosmosdb_sql_database" "literal" {
  name                = "literal"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = "rootform-platform"
}

resource "azurerm_cosmosdb_sql_container" "unknown" {
  name                = "unknown"
  resource_group_name = azurerm_resource_group.platform.name
  account_name        = azurerm_cosmosdb_account.platform.name
  database_name       = var.unknown_id
  partition_key_paths = ["/id"]
}

resource "azurerm_cosmosdb_sql_dedicated_gateway" "unknown" {
  cosmosdb_account_id = var.unknown_id
  instance_count      = 1
  instance_size       = "Cosmos.D4s"
}
