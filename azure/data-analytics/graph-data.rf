# Maintained directly from pinned provider evidence.
concept "graph-data-connect-account" {
  description = "A Microsoft Graph Data Connect service account."
}

rule "graph-data-connect-account" {
  match {
    type = "azurerm_graph_services_account"
  }

  as = concept.graph-data-connect-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
