concept "consul-configuration" {
  description = "A legacy snapshot or supporting setting for an HCP Consul Dedicated cluster."
}

concept "consul-dedicated-cluster" {
  description = "A legacy HCP Consul Dedicated cluster retained for provider-state architecture after end of life."
}

rule "consul-cluster" {
  match {
    type = "hcp_consul_cluster"
  }

  as = concept.consul-dedicated-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "replicates-from" {
    to  = concept.consul-dedicated-cluster
    via = source.primary_link
  }
}

rule "consul-cluster-lookup" {
  match {
    kind = "data"
    type = "hcp_consul_cluster"
  }

  as = concept.consul-dedicated-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "replicates-from" {
    to  = concept.consul-dedicated-cluster
    via = source.primary_link
  }
}

rule "consul-snapshot" {
  match {
    type = "hcp_consul_snapshot"
  }

  as = concept.consul-configuration

  contribution {
    to  = concept.consul-dedicated-cluster
    via = source.cluster_id
  }
}
