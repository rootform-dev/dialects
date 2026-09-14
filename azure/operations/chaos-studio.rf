# Maintained directly from pinned provider evidence.
concept "chaos-experiment" {
  description = "An Azure Chaos Studio experiment."
}

rule "chaos-studio-experiment" {
  match {
    type = "azurerm_chaos_studio_experiment"
  }

  as = concept.chaos-experiment

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
