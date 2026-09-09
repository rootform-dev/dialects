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

resource "azurerm_key_vault" "platform" {
  name                = "rootform-platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  tenant_id           = "00000000-0000-0000-0000-000000000001"
  sku_name            = "standard"
}

variable "database_password" {
  type      = string
  sensitive = true
}

resource "azurerm_key_vault_secret" "database_password" {
  name         = "database-password"
  value        = var.database_password
  key_vault_id = azurerm_key_vault.platform.id
}

resource "azurerm_key_vault_key" "signing" {
  name         = "signing"
  key_vault_id = azurerm_key_vault.platform.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["sign", "verify"]
}

resource "azurerm_key_vault_certificate" "ingress" {
  name         = "ingress"
  key_vault_id = azurerm_key_vault.platform.id
}

resource "azurerm_key_vault_access_policy" "workload" {
  key_vault_id       = azurerm_key_vault.platform.id
  tenant_id          = "00000000-0000-0000-0000-000000000001"
  object_id          = "00000000-0000-0000-0000-000000000002"
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_managed_hardware_security_module" "platform" {
  name                = "rootform-hsm"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku_name            = "Standard_B1"
  tenant_id           = "00000000-0000-0000-0000-000000000001"
  admin_object_ids    = ["00000000-0000-0000-0000-000000000002"]
}

resource "azurerm_key_vault_managed_hardware_security_module_key" "wrapping" {
  name           = "wrapping"
  managed_hsm_id = azurerm_key_vault_managed_hardware_security_module.platform.id
  key_type       = "RSA-HSM"
  key_size       = 2048
  key_opts       = ["wrapKey", "unwrapKey"]
}

# literal and unknown vault references produce no ownership context or contribution
resource "azurerm_key_vault_secret" "literal" {
  name         = "literal"
  value        = var.database_password
  key_vault_id = "/subscriptions/example/vaults/rootform-platform"
}

resource "azurerm_key_vault_key" "unknown" {
  name         = "unknown"
  key_vault_id = var.unknown_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["sign"]
}

resource "azurerm_key_vault_certificate" "unknown" {
  name         = "unknown"
  key_vault_id = var.unknown_id
}
