# Maintained directly from pinned provider evidence.
rule "arc-kubernetes-cluster" {
  match {
    type = "azurerm_arc_kubernetes_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "arc-provisioned-kubernetes-cluster" {
  match {
    type = "azurerm_arc_kubernetes_provisioned_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
