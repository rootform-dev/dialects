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

resource "azurerm_storage_account" "platform" {
  name                     = "rootformplatform"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "media" {
  name               = "media"
  storage_account_id = azurerm_storage_account.platform.id
}

resource "azurerm_storage_queue" "orders" {
  name               = "orders"
  storage_account_id = azurerm_storage_account.platform.id
}

resource "azurerm_storage_table" "sessions" {
  name               = "sessions"
  storage_account_id = azurerm_storage_account.platform.id
}

resource "azurerm_storage_share" "exports" {
  name               = "exports"
  storage_account_id = azurerm_storage_account.platform.id
  quota              = 50
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake" {
  name               = "lake"
  storage_account_id = azurerm_storage_account.platform.id
}

resource "azurerm_storage_blob" "logo" {
  name                 = "logo.png"
  storage_container_id = azurerm_storage_container.media.id
  type                 = "Block"
}

resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.platform.id
}

resource "azurerm_storage_encryption_scope" "customer" {
  name               = "customer"
  storage_account_id = azurerm_storage_account.platform.id
  source             = "Microsoft.Storage"
}

resource "azurerm_storage_table_entity" "session" {
  storage_table_id = azurerm_storage_table.sessions.id
  partition_key    = "web"
  row_key          = "session-1"
  entity           = { state = "active" }
}

# literal and unknown account references produce no ownership context or contribution
resource "azurerm_storage_container" "literal" {
  name               = "literal"
  storage_account_id = "/subscriptions/example/storageAccounts/rootformplatform"
}

resource "azurerm_storage_queue" "unknown" {
  name               = "unknown"
  storage_account_id = var.unknown_id
}

resource "azurerm_storage_blob" "unknown" {
  name                 = "unknown.bin"
  storage_container_id = var.unknown_id
  type                 = "Block"
}
