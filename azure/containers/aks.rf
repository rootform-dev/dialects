rule "aks-cluster" {
  match {
    type = "azurerm_kubernetes_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.default_node_pool[0].vnet_subnet_id
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }

  relation "observed-by" {
    to  = concept.log-analytics-workspace
    via = source.oms_agent[0].log_analytics_workspace_id
  }
}

rule "aks-node-pool" {
  match {
    type = "azurerm_kubernetes_cluster_node_pool"
  }

  as = concept.kubernetes-node-pool

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.vnet_subnet_id
  }

  contribution {
    to  = rf.concept.kubernetes-cluster
    via = source.kubernetes_cluster_id
  }
}
