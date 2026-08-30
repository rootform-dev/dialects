terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_compute_network" "vpc" {
  name = "primary"
}

resource "google_sql_database_instance" "db" {
  name = "records"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      private_network = google_compute_network.vpc.id
    }
  }
}
