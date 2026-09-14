# Maintained directly from pinned provider evidence.
rule "service-bus-namespace" {
  match {
    type = "azurerm_servicebus_namespace"
  }

  as = concept.messaging-namespace

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "service-bus-queue" {
  match {
    type = "azurerm_servicebus_queue"
  }

  as = concept.message-queue

  context {
    as  = context.ownership
    to  = concept.messaging-namespace
    via = source.namespace_id
  }
}

rule "service-bus-subscription" {
  match {
    type = "azurerm_servicebus_subscription"
  }

  as = concept.message-subscription

  context {
    as  = context.ownership
    to  = concept.service-bus-topic
    via = source.topic_id
  }

  relation "subscribes-to" {
    to  = concept.service-bus-topic
    via = source.topic_id
  }
}

rule "service-bus-subscription-rule" {
  match {
    type = "azurerm_servicebus_subscription_rule"
  }

  as = concept.messaging-detail
}

rule "service-bus-topic" {
  match {
    type = "azurerm_servicebus_topic"
  }

  as = concept.service-bus-topic

  context {
    as  = context.ownership
    to  = concept.messaging-namespace
    via = source.namespace_id
  }
}
