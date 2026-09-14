# Maintained directly from pinned provider evidence.
concept "analytics-pool" {
  description = "A SQL or Apache Spark analytics pool."
}

concept "synapse-workspace" {
  description = "An Azure Synapse Analytics workspace."
}

rule "synapse-spark-pool" {
  match {
    type = "azurerm_synapse_spark_pool"
  }

  as = concept.analytics-pool
}

rule "synapse-sql-pool" {
  match {
    type = "azurerm_synapse_sql_pool"
  }

  as = concept.analytics-pool
}

rule "synapse-workspace" {
  match {
    type = "azurerm_synapse_workspace"
  }

  as = concept.synapse-workspace

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
