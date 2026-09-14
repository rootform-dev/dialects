# Maintained directly from pinned provider evidence.
concept "ddos-protection-plan" {
  description = "An Azure DDoS Protection plan protecting virtual networks."
}

rule "ddos-protection-plan" {
  match {
    type = "azurerm_network_ddos_protection_plan"
  }

  as = concept.ddos-protection-plan

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
