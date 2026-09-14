concept "organization-connection" {
  description = "A Datadog cross-organization metrics or logs visibility connection."
}

rule "child-organization" {
  match {
    type = "datadog_child_organization"
  }

  as = concept.observability-tenant
}

rule "org-connection" {
  match {
    type = "datadog_org_connection"
  }

  as = concept.organization-connection

  relation "shares-telemetry-with" {
    to  = concept.observability-tenant
    via = source.sink_org_id
  }
}
