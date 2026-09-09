terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_project" "platform" {
  name       = "platform"
  project_id = "demo-project"
}

resource "google_compute_network" "vpc" {
  name = "primary"
}

resource "google_sql_database_instance" "db" {
  name    = "records"
  project = google_project.platform.project_id

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      private_network = google_compute_network.vpc.id
    }
  }
}

resource "google_sql_database_instance" "provider_default_project" {
  name = "provider-default-project"
  settings { tier = "db-f1-micro" }
}
