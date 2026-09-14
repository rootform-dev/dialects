# Maintained directly from pinned provider evidence.
concept "netapp-account" {
  description = "An Azure NetApp Files account."
}

concept "netapp-capacity-pool" {
  description = "An Azure NetApp Files capacity pool."
}

rule "netapp-account" {
  match {
    type = "azurerm_netapp_account"
  }

  as = concept.netapp-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "netapp-capacity-pool" {
  match {
    type = "azurerm_netapp_pool"
  }

  as = concept.netapp-capacity-pool

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "netapp-volume" {
  match {
    type = "azurerm_netapp_volume"
  }

  as = concept.managed-file-storage

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
