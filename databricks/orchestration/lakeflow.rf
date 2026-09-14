concept "lakeflow-pipeline" {
  description = "A Lakeflow pipeline running declarative batch or streaming data processing."
}

concept "orchestration-configuration" {
  description = "A task, query, repository, or environment artifact supporting Databricks orchestration."
}

rule "lakeflow-job" {
  match {
    type = "databricks_job"
  }

  as = concept.workflow

  relation "runs-on" {
    to  = concept.compute-cluster
    via = source.existing_cluster_id
  }
}

rule "lakeflow-pipeline" {
  match {
    type = "databricks_pipeline"
  }

  as = concept.lakeflow-pipeline

  relation "publishes-to-catalog" {
    to  = concept.unity-catalog-catalog
    via = source.catalog
  }

  relation "publishes-to-schema" {
    to  = concept.unity-catalog-schema
    via = source.target
  }
}
