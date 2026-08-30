terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_compute_network" "runtime" {
  name = "runtime"
}

resource "google_compute_subnetwork" "runtime" {
  name          = "runtime"
  region        = "europe-west1"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.runtime.id
}

resource "google_cloud_run_v2_service" "api" {
  name     = "api"
  location = "europe-west1"

  template {
    containers {
      image = "europe-west1-docker.pkg.dev/example/apps/api:stable"
    }

    vpc_access {
      network_interfaces {
        network    = google_compute_network.runtime.id
        subnetwork = google_compute_subnetwork.runtime.id
      }
    }
  }
}

resource "google_cloud_run_v2_job" "migration" {
  name     = "migration"
  location = "europe-west1"

  template {
    template {
      containers {
        image = "europe-west1-docker.pkg.dev/example/apps/migration:stable"
      }
    }
  }
}
