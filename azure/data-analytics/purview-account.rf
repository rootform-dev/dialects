# Maintained directly from pinned provider evidence.
concept "purview-account" {
  description = "A Microsoft Purview data governance account."
}

rule "purview-account" {
  match {
    type = "azurerm_purview_account"
  }

  as = concept.purview-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
