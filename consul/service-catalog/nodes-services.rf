
concept "consul-node" {
  description = "A node registered in the Consul service catalog."
}

concept "consul-service" {
  description = "A service registered or selected in the Consul catalog."
}

rule "agent-service" {
  match {
    type = "consul_agent_service"
  }

  as = concept.consul-service
}


rule "catalog-service-lookup" {
  match {
    kind = "data"
    type = "consul_catalog_service"
  }

  as = concept.consul-service
}

rule "node" {
  match {
    type = "consul_node"
  }

  as = concept.consul-node
}

rule "service" {
  match {
    type = "consul_service"
  }

  as = concept.consul-service

  context {
    as  = rf.context.runtime
    to  = concept.consul-node
    via = source.node
  }

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "service-lookup" {
  match {
    kind = "data"
    type = "consul_service"
  }

  as = concept.consul-service
}
