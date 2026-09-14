# Maintained directly from pinned provider evidence.
concept "virtual-desktop-application-group" {
  description = "An Azure Virtual Desktop desktop or RemoteApp publication group."
}

concept "virtual-desktop-host-pool" {
  description = "An Azure Virtual Desktop host pool providing session hosts."
}

concept "virtual-desktop-workspace" {
  description = "An Azure Virtual Desktop workspace publishing application groups."
}

rule "virtual-desktop-application" {
  match {
    type = "azurerm_virtual_desktop_application"
  }

  as = concept.compute-placement
}

rule "virtual-desktop-application-group" {
  match {
    type = "azurerm_virtual_desktop_application_group"
  }

  as = concept.virtual-desktop-application-group

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "virtual-desktop-host-pool" {
  match {
    type = "azurerm_virtual_desktop_host_pool"
  }

  as = concept.virtual-desktop-host-pool

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "virtual-desktop-scaling-plan" {
  match {
    type = "azurerm_virtual_desktop_scaling_plan"
  }

  as = concept.compute-placement
}

rule "virtual-desktop-workspace" {
  match {
    type = "azurerm_virtual_desktop_workspace"
  }

  as = concept.virtual-desktop-workspace

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
