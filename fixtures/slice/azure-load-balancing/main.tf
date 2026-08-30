terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.3.0"
    }
  }
}

resource "azurerm_resource_group" "edge" {
  name     = "edge"
  location = "West Europe"
}

resource "azurerm_virtual_network" "edge" {
  name                = "edge"
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name
  address_space       = ["10.50.0.0/16"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "gateway"
  resource_group_name  = azurerm_resource_group.edge.name
  virtual_network_name = azurerm_virtual_network.edge.name
  address_prefixes     = ["10.50.1.0/24"]
}

resource "azurerm_public_ip" "edge" {
  name                = "edge"
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "transport" {
  name                = "transport"
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.edge.id
  }
}

resource "azurerm_lb_backend_address_pool" "workers" {
  name            = "workers"
  loadbalancer_id = azurerm_lb.transport.id
}

resource "azurerm_lb_rule" "https" {
  name                           = "https"
  loadbalancer_id                = azurerm_lb.transport.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.workers.id]
}

resource "azurerm_application_gateway" "web" {
  name                = "web"
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway"
    subnet_id = azurerm_subnet.gateway.id
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.edge.id
  }

  backend_address_pool {
    name = "workloads"
  }

  backend_http_settings {
    name                  = "https"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
  }

  http_listener {
    name                           = "https"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "https"
    protocol                       = "Https"
  }

  request_routing_rule {
    name                       = "default"
    priority                   = 10
    rule_type                  = "Basic"
    http_listener_name         = "https"
    backend_address_pool_name  = "workloads"
    backend_http_settings_name = "https"
  }
}
