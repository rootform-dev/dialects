terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_virtual_network" "platform" {
  name          = "platform"
  address_space = ["10.70.0.0/16"]
}

resource "azurerm_resource_group" "shared_a" {
  name     = "shared"
  location = "West Europe"
}

resource "azurerm_resource_group" "shared_b" {
  name     = "shared"
  location = "West Europe"
}

resource "azurerm_subnet" "dynamic" {
  name                 = "dynamic"
  virtual_network_name = "external-network"
  address_prefixes     = ["10.70.1.0/24"]
}

resource "azurerm_subnet" "absent" {
  name             = "absent"
  address_prefixes = ["10.70.2.0/24"]
}

resource "azurerm_subnet" "dangling" {
  name                 = "dangling"
  virtual_network_name = azurerm_virtual_network.missing.name
  address_prefixes     = ["10.70.3.0/24"]
}

resource "azurerm_subnet" "mismatch" {
  name                 = "mismatch"
  virtual_network_name = azurerm_kubernetes_cluster.absent.name
  address_prefixes     = ["10.70.4.0/24"]
}

resource "azurerm_kubernetes_cluster" "absent" {
  name = "absent"

  default_node_pool {
    name = "system"
  }
}

resource "azurerm_kubernetes_cluster" "dynamic" {
  name = "dynamic"

  default_node_pool {
    name           = "system"
    vnet_subnet_id = "/synthetic/subnets/external"
  }
}

resource "azurerm_kubernetes_cluster" "dangling" {
  name = "dangling"

  default_node_pool {
    name           = "system"
    vnet_subnet_id = azurerm_subnet.missing.id
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "mismatch" {
  name                  = "mismatch"
  kubernetes_cluster_id = azurerm_virtual_network.platform.id
}

resource "azurerm_postgresql_flexible_server" "mismatch" {
  name                = "mismatch"
  delegated_subnet_id = azurerm_virtual_network.platform.id
}

resource "azurerm_postgresql_flexible_server" "absent" {
  name = "absent"
}

resource "azurerm_postgresql_flexible_server" "dynamic" {
  name                = "dynamic"
  delegated_subnet_id = "/subscriptions/example/subnets/external"
}

resource "azurerm_postgresql_flexible_server" "dangling" {
  name                = "dangling"
  delegated_subnet_id = azurerm_subnet.missing.id
}

resource "azurerm_storage_account" "absent" {
  name = "rootformabsent"
}

resource "azurerm_storage_account" "ambiguous" {
  name                = "rootformambiguous"
  resource_group_name = "shared"
}

resource "azurerm_storage_account" "mismatch" {
  name                = "rootformmismatch"
  resource_group_name = azurerm_virtual_network.platform.name
}

resource "azurerm_mssql_server" "server" {
  name = "server"
}

resource "azurerm_mssql_database" "absent" {
  name = "absent"
}

resource "azurerm_mssql_database" "dangling" {
  name      = "dangling"
  server_id = azurerm_mssql_server.missing.id
}

resource "azurerm_mssql_database" "mismatch" {
  name      = "mismatch"
  server_id = azurerm_virtual_network.platform.id
}

resource "azurerm_lb" "transport" {
  name = "transport"
}

resource "azurerm_lb_backend_address_pool" "absent" {
  name = "absent"
}

resource "azurerm_lb_backend_address_pool" "dangling" {
  name            = "dangling"
  loadbalancer_id = azurerm_lb.missing.id
}

resource "azurerm_lb_rule" "mismatch" {
  name            = "mismatch"
  loadbalancer_id = azurerm_virtual_network.platform.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "absent" {
  name = "absent"
}

resource "azurerm_private_dns_zone_virtual_network_link" "mismatch" {
  name                = "mismatch"
  private_dns_zone_id = azurerm_virtual_network.platform.id
}

resource "azurerm_private_endpoint" "absent" {
  name = "absent"
}

resource "azurerm_private_endpoint" "dangling" {
  name      = "dangling"
  subnet_id = azurerm_subnet.missing.id
}

resource "azurerm_private_endpoint" "mismatch" {
  name      = "mismatch"
  subnet_id = azurerm_virtual_network.platform.id
}
