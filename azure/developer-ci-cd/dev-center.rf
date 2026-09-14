# Maintained directly from pinned provider evidence.
concept "dev-center" {
  description = "A Microsoft Dev Box and deployment-environment Dev Center."
}

concept "dev-center-project" {
  description = "A Dev Center project boundary."
}

rule "dev-center" {
  match {
    type = "azurerm_dev_center"
  }

  as = concept.dev-center

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "dev-center-project" {
  match {
    type = "azurerm_dev_center_project"
  }

  as = concept.dev-center-project

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
