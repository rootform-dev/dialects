terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.129.0"
    }
  }
}

resource "databricks_metastore" "platform" {
  name   = "Platform"
  region = "us-east-1"
}

resource "databricks_catalog" "analytics" {
  name         = "analytics"
  metastore_id = databricks_metastore.platform.id
}

resource "databricks_schema" "curated" {
  name         = "curated"
  catalog_name = databricks_catalog.analytics.name
}

resource "databricks_instance_pool" "shared" {
  instance_pool_name = "Shared compute"
  min_idle_instances = 0
  max_capacity       = 20
  node_type_id       = "i3.xlarge"
}

resource "databricks_cluster" "engineering" {
  cluster_name     = "Engineering"
  spark_version   = "17.3.x-scala2.12"
  instance_pool_id = databricks_instance_pool.shared.id
  num_workers      = 2
}

resource "databricks_sql_endpoint" "analytics" {
  name             = "Analytics"
  cluster_size     = "Small"
  max_num_clusters = 2
}

resource "databricks_pipeline" "orders" {
  name    = "Orders"
  catalog = databricks_catalog.analytics.name
  target  = databricks_schema.curated.name
}

resource "databricks_job" "daily" {
  name                = "Daily orders"
  existing_cluster_id = databricks_cluster.engineering.id
}

resource "databricks_model_serving" "fraud" {
  name = "fraud-detection"
}
