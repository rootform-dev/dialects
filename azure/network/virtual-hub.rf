# Maintained directly from pinned provider evidence.

concept "virtual-hub" {
  description = "An Azure Virtual WAN regional transit hub."
}

rule "virtual-hub" {
  match {
    type = "azurerm_virtual_hub"
  }

  as = concept.virtual-hub

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
