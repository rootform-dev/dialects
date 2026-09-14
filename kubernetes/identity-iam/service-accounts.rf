concept "service-account" {
  description = "An identity a pod runs under inside the cluster."
}

rule "kubernetes-service-account" {
  match {
    type = "kubernetes_service_account_v1"
  }

  as = concept.service-account

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
