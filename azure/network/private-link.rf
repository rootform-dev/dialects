# Maintained directly from pinned provider evidence.
concept "private-link-service" {
  description = "An Azure Private Link service publishing a private endpoint target."
}

rule "private-link-service" {
  match {
    type = "azurerm_private_link_service"
  }

  as = concept.private-link-service

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
