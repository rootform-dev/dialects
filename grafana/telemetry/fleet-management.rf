concept "telemetry-collector" {
  description = "A Grafana Alloy or OpenTelemetry Collector managed through Grafana Fleet Management."
}


rule "fleet-management-collector" {
  match {
    type = "grafana_fleet_management_collector"
  }

  as = concept.telemetry-collector
}

rule "fleet-management-collector-lookup" {
  match {
    kind = "data"
    type = "grafana_fleet_management_collector"
  }

  as = concept.telemetry-collector
}
