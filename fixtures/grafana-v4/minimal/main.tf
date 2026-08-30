terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "4.45.2"
    }
  }
}

resource "grafana_cloud_stack" "platform" {
  name        = "platform"
  slug        = "platform"
  region_slug = "prod-us-east-0"
}

resource "grafana_data_source" "metrics" {
  name = "metrics"
  type = "prometheus"
  url  = "https://metrics.rootform.invalid"
}

resource "grafana_fleet_management_collector" "alloy" {
  id             = "alloy-production"
  collector_type = "ALLOY"
  enabled        = true
}

resource "grafana_fleet_management_pipeline" "telemetry" {
  name        = "telemetry"
  contents    = "prometheus.exporter.self rootform {}"
  enabled     = true
  config_type = "alloy"
}
