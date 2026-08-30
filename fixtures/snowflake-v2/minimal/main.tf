terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "2.20.0"
    }
  }
}

resource "snowflake_database" "analytics" {
  name = "ANALYTICS"
}

resource "snowflake_schema" "pipelines" {
  database = snowflake_database.analytics.fully_qualified_name
  name     = "PIPELINES"
}

resource "snowflake_warehouse" "transform" {
  name = "TRANSFORM"
}

resource "snowflake_dynamic_table" "orders" {
  database  = snowflake_database.analytics.name
  schema    = snowflake_schema.pipelines.fully_qualified_name
  name      = "ORDERS"
  warehouse = snowflake_warehouse.transform.fully_qualified_name
  query     = "select 1"
}

resource "snowflake_task" "refresh" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "REFRESH"
  warehouse     = snowflake_warehouse.transform.fully_qualified_name
  sql_statement = "select 1"
}
