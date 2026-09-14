concept "data-source" {
  description = "A Grafana connection to an external or hosted telemetry data source."
}

rule "data-source" {
  match {
    type = "grafana_data_source"
  }

  as = concept.data-source

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.org_id
  }

  relation "connects-through" {
    to  = concept.private-data-source-connect-network
    via = source.private_data_source_connect_network_id
  }
}

rule "data-source-lookup" {
  match {
    kind = "data"
    type = "grafana_data_source"
  }

  as = concept.data-source

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.org_id
  }

  relation "connects-through" {
    to  = concept.private-data-source-connect-network
    via = source.private_data_source_connect_network_id
  }
}
