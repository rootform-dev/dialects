rule "cloud-stack" {
  match {
    type = "grafana_cloud_stack"
  }

  as = concept.observability-tenant
}

rule "cloud-stack-lookup" {
  match {
    kind = "data"
    type = "grafana_cloud_stack"
  }

  as = concept.observability-tenant
}
