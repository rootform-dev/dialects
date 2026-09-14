rule "virtual-network" {
  match {
    type = "azurerm_virtual_network"
  }

  as = rf.concept.virtual-network

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}

rule "subnet" {
  match {
    type = "azurerm_subnet"
  }

  as = rf.concept.subnet

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.virtual_network_name
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}
