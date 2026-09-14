# Maintained directly from pinned provider evidence.
concept "compute-image" {
  description = "A reusable Azure compute image or image definition."
}

rule "compute-image" {
  match {
    type = "azurerm_image"
  }

  as = concept.compute-image

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "shared-image" {
  match {
    type = "azurerm_shared_image"
  }

  as = concept.compute-image

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
