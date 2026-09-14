rule "private-endpoint" {
  match {
    type = "azurerm_private_endpoint"
  }

  as = concept.private-endpoint

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.subnet_id
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
