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

resource "azurerm_eventhub_namespace" "platform" {
  name                = "rootform-platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Standard"
}

resource "azurerm_eventhub" "clicks" {
  name              = "clicks"
  namespace_id      = azurerm_eventhub_namespace.platform.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_consumer_group" "analytics" {
  name                = "analytics"
  namespace_name      = azurerm_eventhub_namespace.platform.name
  eventhub_name       = azurerm_eventhub.clicks.name
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_eventhub_namespace_schema_group" "clicks" {
  name                 = "clicks"
  namespace_id         = azurerm_eventhub_namespace.platform.id
  schema_compatibility = "Forward"
  schema_type          = "Avro"
}

resource "azurerm_eventgrid_domain" "commerce" {
  name                = "commerce"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
}

resource "azurerm_eventgrid_domain_topic" "orders" {
  name                = "orders"
  domain_name         = azurerm_eventgrid_domain.commerce.name
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_eventgrid_namespace" "streams" {
  name                = "streams"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
}

resource "azurerm_eventgrid_namespace_topic" "telemetry" {
  name                   = "telemetry"
  eventgrid_namespace_id = azurerm_eventgrid_namespace.streams.id
}

# literal and unknown parent references produce no ownership context or contribution
resource "azurerm_eventhub" "literal" {
  name              = "literal"
  namespace_id      = "/subscriptions/example/namespaces/rootform-platform"
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventgrid_domain_topic" "unknown" {
  name                = "unknown"
  domain_name         = var.unknown_id
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_eventhub_consumer_group" "literal" {
  name                = "literal"
  namespace_name      = azurerm_eventhub_namespace.platform.name
  eventhub_name       = "clicks"
  resource_group_name = azurerm_resource_group.platform.name
}
