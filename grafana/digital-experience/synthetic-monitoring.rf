rule "synthetic-monitoring-check" {
  match {
    type = "grafana_synthetic_monitoring_check"
  }

  as = concept.synthetic-check

  contribution {
    to  = concept.synthetic-execution-location
    via = source.probes
  }
}

rule "synthetic-monitoring-probe" {
  match {
    type = "grafana_synthetic_monitoring_probe"
  }

  as = concept.synthetic-execution-location
}

rule "synthetic-monitoring-probe-lookup" {
  match {
    kind = "data"
    type = "grafana_synthetic_monitoring_probe"
  }

  as = concept.synthetic-execution-location
}
