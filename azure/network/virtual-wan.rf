# Maintained directly from pinned provider evidence.
concept "virtual-wan" {
  description = "An Azure Virtual WAN global transit network."
}

rule "virtual-wan" {
  match {
    type = "azurerm_virtual_wan"
  }

  as = concept.virtual-wan

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
