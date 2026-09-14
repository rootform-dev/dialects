concept "quality-monitor" {
  description = "A Databricks monitor evaluating data or model quality over time."
}


rule "data-quality-monitor" {
  match {
    type = "databricks_data_quality_monitor"
  }

  as = concept.quality-monitor
}

rule "lakehouse-monitor" {
  match {
    type = "databricks_lakehouse_monitor"
  }

  as = concept.quality-monitor
}

rule "quality-monitor" {
  match {
    type = "databricks_quality_monitor"
  }

  as = concept.quality-monitor
}

rule "quality-monitor-v2" {
  match {
    type = "databricks_quality_monitor_v2"
  }

  as = concept.quality-monitor
}
