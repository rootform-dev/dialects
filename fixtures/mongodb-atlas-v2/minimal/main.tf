terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.16.0"
    }
  }
}

resource "mongodbatlas_organization" "platform" {
  name = "Rootform"
}

resource "mongodbatlas_project" "application" {
  name   = "application"
  org_id = mongodbatlas_organization.platform.id
}

resource "mongodbatlas_advanced_cluster" "primary" {
  project_id = mongodbatlas_project.application.id
  name       = "primary"
}

resource "mongodbatlas_cloud_backup_snapshot_export_bucket" "archive" {
  project_id = mongodbatlas_project.application.id
}

resource "mongodbatlas_cloud_backup_schedule" "primary" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name

  export {
    export_bucket_id = mongodbatlas_cloud_backup_snapshot_export_bucket.archive.id
  }
}

resource "mongodbatlas_search_deployment" "primary" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
}

resource "mongodbatlas_online_archive" "orders" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
}

resource "mongodbatlas_stream_workspace" "events" {
  project_id = mongodbatlas_project.application.id
  name       = "events"
}

resource "mongodbatlas_stream_processor" "orders" {
  project_id     = mongodbatlas_project.application.id
  workspace_name = mongodbatlas_stream_workspace.events.name
  name           = "orders"
  pipeline       = "ROOTFORM_ATLAS_PIPELINE_SENTINEL"
}
