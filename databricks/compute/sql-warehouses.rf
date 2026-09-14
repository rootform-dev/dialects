
concept "sql-configuration" {
  description = "Configuration or access control supporting Databricks SQL."
}


rule "sql-global-config" {
  match {
    type = "databricks_sql_global_config"
  }

  as = concept.sql-configuration
}

rule "sql-permissions" {
  match {
    type = "databricks_sql_permissions"
  }

  as = concept.sql-configuration
}
