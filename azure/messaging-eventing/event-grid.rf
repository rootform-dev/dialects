# Maintained directly from pinned provider evidence.
concept "event-grid-domain" {
  description = "An Azure Event Grid domain or namespace owning event topics."
}

rule "event-grid-domain" {
  match {
    type = "azurerm_eventgrid_domain"
  }

  as = concept.event-grid-domain

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "event-grid-domain-topic" {
  match {
    type = "azurerm_eventgrid_domain_topic"
  }

  as = concept.event-grid-topic

  context {
    as  = context.ownership
    to  = concept.event-grid-domain
    via = source.domain_name
  }
}

rule "event-grid-event-subscription" {
  match {
    type = "azurerm_eventgrid_event_subscription"
  }

  as = concept.message-subscription

  relation "delivers-to" {
    to  = concept.event-stream
    via = source.eventhub_id
  }

  relation "delivers-to" {
    to  = concept.message-queue
    via = source.service_bus_queue_id
  }

  relation "delivers-to" {
    to  = concept.service-bus-topic
    via = source.service_bus_topic_id
  }

  relation "delivers-to" {
    to  = concept.serverless-function
    via = source.azure_function_endpoint[0].function_id
  }

  relation "delivers-to" {
    to  = concept.storage-account
    via = source.storage_queue_endpoint[0].storage_account_id
  }
}

rule "event-grid-namespace" {
  match {
    type = "azurerm_eventgrid_namespace"
  }

  as = concept.event-grid-domain

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "event-grid-namespace-topic" {
  match {
    type = "azurerm_eventgrid_namespace_topic"
  }

  as = concept.message-topic

  context {
    as  = context.ownership
    to  = concept.event-grid-domain
    via = source.eventgrid_namespace_id
  }
}

rule "event-grid-partner-namespace" {
  match {
    type = "azurerm_eventgrid_partner_namespace"
  }

  as = concept.event-grid-domain

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "event-grid-system-topic" {
  match {
    type = "azurerm_eventgrid_system_topic"
  }

  as = concept.event-grid-topic

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "event-grid-system-topic-subscription" {
  match {
    type = "azurerm_eventgrid_system_topic_event_subscription"
  }

  as = concept.message-subscription

  context {
    as  = context.ownership
    to  = concept.event-grid-topic
    via = source.system_topic
  }

  relation "subscribes-to" {
    to  = concept.event-grid-topic
    via = source.system_topic
  }

  relation "delivers-to" {
    to  = concept.event-stream
    via = source.eventhub_id
  }

  relation "delivers-to" {
    to  = concept.message-queue
    via = source.service_bus_queue_id
  }

  relation "delivers-to" {
    to  = concept.service-bus-topic
    via = source.service_bus_topic_id
  }

  relation "delivers-to" {
    to  = concept.serverless-function
    via = source.azure_function_endpoint[0].function_id
  }

  relation "delivers-to" {
    to  = concept.storage-account
    via = source.storage_queue_endpoint[0].storage_account_id
  }
}

rule "event-grid-topic" {
  match {
    type = "azurerm_eventgrid_topic"
  }

  as = concept.event-grid-topic

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
