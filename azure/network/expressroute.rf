# Maintained directly from pinned provider evidence.
concept "expressroute-gateway" {
  description = "An Azure ExpressRoute gateway connecting a virtual network to private circuits."
}

rule "expressroute-circuit" {
  match {
    type = "azurerm_express_route_circuit"
  }

  as = concept.dedicated-interconnect

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "expressroute-gateway" {
  match {
    type = "azurerm_express_route_gateway"
  }

  as = concept.expressroute-gateway

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "expressroute-port" {
  match {
    type = "azurerm_express_route_port"
  }

  as = concept.dedicated-interconnect

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
