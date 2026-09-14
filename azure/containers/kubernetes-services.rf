# Maintained directly from pinned provider evidence.
rule "automatic-kubernetes-cluster" {
  match {
    type = "azurerm_kubernetes_automatic_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "red-hat-openshift-cluster" {
  match {
    type = "azurerm_redhat_openshift_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
