rule "organization" {
  match {
    type = "grafana_organization"
  }

  as = concept.observability-tenant
}

rule "organization-lookup" {
  match {
    kind = "data"
    type = "grafana_organization"
  }

  as = concept.observability-tenant
}
