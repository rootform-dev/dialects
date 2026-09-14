# Maintained directly from pinned provider evidence.
concept "maps-account" {
  description = "An Azure Maps account exposing geospatial platform APIs."
}

rule "maps-account" {
  match {
    type = "azurerm_maps_account"
  }

  as = concept.maps-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
