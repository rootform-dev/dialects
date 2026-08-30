terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

resource "azurerm_virtual_network" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.60.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.60.1.0/24"]
}

resource "azurerm_subnet" "data" {
  name                 = "data"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.60.2.0/24"]

  delegation {
    name = "postgresql"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_kubernetes_cluster" "workloads" {
  name                = "workloads"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  dns_prefix          = "workloads"

  default_node_pool {
    name           = "system"
    node_count     = 2
    vm_size        = "Standard_D2s_v5"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "workers" {
  name                  = "workers"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.workloads.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 3
  vnet_subnet_id        = azurerm_subnet.aks.id
}

resource "azurerm_postgresql_flexible_server" "records" {
  name                          = "records"
  resource_group_name           = azurerm_resource_group.platform.name
  location                      = azurerm_resource_group.platform.location
  version                       = "17"
  delegated_subnet_id           = azurerm_subnet.data.id
  public_network_access_enabled = false
  sku_name                      = "B_Standard_B1ms"
}

resource "azurerm_lb" "internal" {
  name                = "internal"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "edge" {
  name                = "edge"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_user_assigned_identity" "workload" {
  name                = "workload"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_mssql_server" "unsupported" {
  name                = "unsupported"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  version             = "12.0"
}

resource "azurerm_mssql_database" "unsupported" {
  name      = "unsupported"
  server_id = azurerm_mssql_server.unsupported.id
}

resource "azurerm_private_endpoint" "unsupported" {
  name                = "unsupported"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  subnet_id           = azurerm_subnet.data.id

  private_service_connection {
    name                           = "unsupported"
    private_connection_resource_id = azurerm_mssql_server.unsupported.id
    is_manual_connection           = false
  }
}

resource "azurerm_storage_account" "unsupported" {
  name                     = "rootformunsupported"
  location                 = azurerm_resource_group.platform.location
  resource_group_name      = azurerm_resource_group.platform.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
