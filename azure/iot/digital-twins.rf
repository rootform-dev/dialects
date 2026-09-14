# Maintained directly from pinned provider evidence.
concept "digital-twins-instance" {
  description = "An Azure Digital Twins service instance."
}

rule "digital-twins-instance" {
  match {
    type = "azurerm_digital_twins_instance"
  }

  as = concept.digital-twins-instance

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
