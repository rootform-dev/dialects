concept "service" {
  description = "A stable network endpoint in front of a set of pods."
}

concept "ingress" {
  description = "HTTP routing into cluster services from outside the cluster."
}

concept "network-policy" {
  description = "A namespace-scoped policy controlling pod network traffic."
}

rule "kubernetes-service" {
  match {
    type = "kubernetes_service_v1"
  }

  as = concept.service

  context {
    as  = rf.context.runtime
    to  = rf.concept.kubernetes-cluster
    via = provider.host
  }

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.metadata[0].namespace

    match {
      by       = target.metadata[0].name
      strategy = "exact"
    }
  }
}

rule "kubernetes-ingress" {
  match {
    type = "kubernetes_ingress_v1"
  }

  as = concept.ingress

  context {
    as  = rf.context.runtime
    to  = rf.concept.kubernetes-cluster
    via = provider.host
  }

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.metadata[0].namespace

    match {
      by       = target.metadata[0].name
      strategy = "exact"
    }
  }
}

rule "kubernetes-network-policy" {
  match {
    type = "kubernetes_network_policy_v1"
  }

  as = concept.network-policy

  context {
    as  = rf.context.runtime
    to  = rf.concept.kubernetes-cluster
    via = provider.host
  }

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.metadata[0].namespace
  }
}
