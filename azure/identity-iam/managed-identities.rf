rule "user-assigned-managed-identity" {
  match {
    type = "azurerm_user_assigned_identity"
  }

  as = rf.concept.service-identity

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
