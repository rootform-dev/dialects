# Maintained directly from pinned provider evidence.
concept "managed-application" {
  description = "An Azure Managed Application deployment."
}

rule "managed-application" {
  match {
    type = "azurerm_managed_application"
  }

  as = concept.managed-application

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
