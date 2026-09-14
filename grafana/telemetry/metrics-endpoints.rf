concept "metrics-scrape-job" {
  description = "A Grafana Cloud scrape job collecting metrics from an explicit endpoint."
}

rule "connections-metrics-endpoint-scrape-job" {
  match {
    type = "grafana_connections_metrics_endpoint_scrape_job"
  }

  as = concept.metrics-scrape-job

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }
}

rule "connections-metrics-endpoint-scrape-job-lookup" {
  match {
    kind = "data"
    type = "grafana_connections_metrics_endpoint_scrape_job"
  }

  as = concept.metrics-scrape-job

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }
}
