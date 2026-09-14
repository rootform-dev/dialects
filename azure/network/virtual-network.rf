# Maintained directly from pinned provider evidence.
concept "virtual-network-manager" {
  description = "An Azure Virtual Network Manager control plane for network groups and policy."
}

rule "virtual-network-manager" {
  match {
    type = "azurerm_network_manager"
  }

  as = concept.virtual-network-manager

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "virtual-network-peering" {
  match {
    type = "azurerm_virtual_network_peering"
  }

  as = concept.network-peering

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.virtual_network_name
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.remote_virtual_network_id
  }
}
