# Maintained directly from pinned provider evidence.
concept "data-explorer-cluster" {
  description = "An Azure Data Explorer cluster serving real-time analytics."
}


rule "data-explorer-cluster" {
  match {
    type = "azurerm_kusto_cluster"
  }

  as = concept.data-explorer-cluster

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}


rule "data-explorer-event-grid-connection" {
  match {
    type = "azurerm_kusto_eventgrid_data_connection"
  }

  as = concept.database-component
}

rule "data-explorer-event-hubs-connection" {
  match {
    type = "azurerm_kusto_eventhub_data_connection"
  }

  as = concept.database-component
}
