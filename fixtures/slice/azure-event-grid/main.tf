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

resource "azurerm_eventhub" "handler" { name = "handler" }
resource "azurerm_servicebus_queue" "handler" { name = "handler" }
resource "azurerm_servicebus_topic" "handler" { name = "handler" }
resource "azurerm_linux_function_app" "handler" { name = "handler" }
resource "azurerm_storage_account" "handler" {
  name                     = "rootformhandler"
  resource_group_name      = azurerm_resource_group.platform.name
  location                 = azurerm_resource_group.platform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_eventgrid_event_subscription" "eventhub" {
  name        = "eventhub"
  scope       = azurerm_resource_group.platform.id
  eventhub_id = azurerm_eventhub.handler.id
}

resource "azurerm_eventgrid_event_subscription" "queue" {
  name                 = "queue"
  scope                = azurerm_resource_group.platform.id
  service_bus_queue_id = azurerm_servicebus_queue.handler.id
}

resource "azurerm_eventgrid_event_subscription" "topic" {
  name                 = "topic"
  scope                = azurerm_resource_group.platform.id
  service_bus_topic_id = azurerm_servicebus_topic.handler.id
}

resource "azurerm_eventgrid_event_subscription" "function" {
  name  = "function"
  scope = azurerm_resource_group.platform.id
  azure_function_endpoint { function_id = azurerm_linux_function_app.handler.id }
}

resource "azurerm_eventgrid_event_subscription" "storage" {
  name  = "storage"
  scope = azurerm_resource_group.platform.id
  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.handler.id
    queue_name         = "events"
  }
}

resource "azurerm_eventgrid_event_subscription" "literal" {
  name        = "literal"
  scope       = azurerm_resource_group.platform.id
  eventhub_id = "/subscriptions/example/eventhubs/handler"
}

resource "azurerm_eventgrid_event_subscription" "unknown" {
  name                 = "unknown"
  scope                = azurerm_resource_group.platform.id
  service_bus_queue_id = var.unknown_id
}
