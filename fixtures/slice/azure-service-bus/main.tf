terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_id" { type = string }

resource "azurerm_resource_group" "messaging" {
  name     = "messaging"
  location = "West Europe"
}

resource "azurerm_servicebus_namespace" "platform" {
  name                = "platform"
  location            = azurerm_resource_group.messaging.location
  resource_group_name = azurerm_resource_group.messaging.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "orders" {
  name         = "orders"
  namespace_id = azurerm_servicebus_namespace.platform.id
}

resource "azurerm_servicebus_topic" "events" {
  name         = "events"
  namespace_id = azurerm_servicebus_namespace.platform.id
}

resource "azurerm_servicebus_subscription" "worker" {
  name               = "worker"
  topic_id           = azurerm_servicebus_topic.events.id
  max_delivery_count = 10
}

resource "azurerm_servicebus_queue" "literal" {
  name         = "literal"
  namespace_id = "/subscriptions/example/namespaces/platform"
}

resource "azurerm_servicebus_queue" "unknown" {
  name         = "unknown"
  namespace_id = var.unknown_id
}

resource "azurerm_servicebus_subscription" "literal" {
  name               = "literal"
  topic_id           = "/subscriptions/example/topics/events"
  max_delivery_count = 10
}

resource "azurerm_servicebus_subscription" "unknown" {
  name               = "unknown"
  topic_id           = var.unknown_id
  max_delivery_count = 10
}
