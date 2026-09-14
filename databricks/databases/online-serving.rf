
concept "online-serving-configuration" {
  description = "An online table or feature-serving configuration supporting Databricks online serving."
}


rule "online-table" {
  match {
    type = "databricks_online_table"
  }

  as = concept.online-serving-configuration

  contribution {
    to  = concept.lakeflow-pipeline
    via = source.spec.pipeline_id
  }
}
