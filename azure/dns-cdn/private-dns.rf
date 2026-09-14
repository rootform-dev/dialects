rule "private-dns-zone" {
  match {
    type = "azurerm_private_dns_zone"
  }

  as = concept.dns-zone

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

rule "private-dns-zone-vnet-link" {
  match {
    type = "azurerm_private_dns_zone_virtual_network_link"
  }

  as = concept.private-network-link

  contribution {
    to  = concept.dns-zone
    via = source.private_dns_zone_id
  }

  contribution {
    to  = rf.concept.virtual-network
    via = source.virtual_network_id
  }
}
