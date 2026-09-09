terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

variable "unknown_id" { type = string }

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

resource "azurerm_virtual_network" "remote" {
  name                = "remote"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.30.0.0/16"]
}

resource "azurerm_virtual_network_peering" "platform" {
  name                      = "platform-to-remote"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.platform.name
  remote_virtual_network_id = azurerm_virtual_network.remote.id
}

resource "azurerm_virtual_network_peering" "remote_to_platform" {
  name                      = "remote-to-platform"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.remote.name
  remote_virtual_network_id = azurerm_virtual_network.platform.id
}

resource "azurerm_virtual_network_peering" "literal" {
  name                      = "literal"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = "platform"
  remote_virtual_network_id = "/subscriptions/example/virtualNetworks/remote"
}

resource "azurerm_virtual_network_peering" "unknown" {
  name                      = "unknown"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = var.unknown_id
  remote_virtual_network_id = var.unknown_id
}

resource "azurerm_nat_gateway" "egress" {
  name                = "egress"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet_nat_gateway_association" "workloads" {
  subnet_id      = azurerm_subnet.workloads.id
  nat_gateway_id = azurerm_nat_gateway.egress.id
}

resource "azurerm_subnet_nat_gateway_association" "unknown" {
  subnet_id      = var.unknown_id
  nat_gateway_id = var.unknown_id
}

resource "azurerm_private_dns_zone" "internal" {
  name                = "internal.example"
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "platform" {
  name                = "platform"
  private_dns_zone_id = azurerm_private_dns_zone.internal.id
  virtual_network_id  = azurerm_virtual_network.platform.id
}

resource "azurerm_public_ip" "egress" {
  name                = "egress"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "egress" {
  name                = "egress"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  prefix_length       = 30
}

resource "azurerm_nat_gateway_public_ip_association" "egress" {
  nat_gateway_id       = azurerm_nat_gateway.egress.id
  public_ip_address_id = azurerm_public_ip.egress.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "egress" {
  nat_gateway_id      = azurerm_nat_gateway.egress.id
  public_ip_prefix_id = azurerm_public_ip_prefix.egress.id
}

resource "azurerm_nat_gateway_public_ip_association" "unknown" {
  nat_gateway_id       = var.unknown_id
  public_ip_address_id = var.unknown_id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "unknown" {
  nat_gateway_id      = azurerm_nat_gateway.egress.id
  public_ip_prefix_id = var.unknown_id
}
