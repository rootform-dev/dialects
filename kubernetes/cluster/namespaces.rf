concept "namespace" {
  description = "A namespace partitioning one cluster's workloads, services, and storage."
}

rule "kubernetes-namespace" {
  match {
    type = "kubernetes_namespace_v1"
  }

  as = concept.namespace

  context {
    as  = rf.context.runtime
    to  = rf.concept.kubernetes-cluster
    via = provider.host
  }
}
