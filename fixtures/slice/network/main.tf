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

resource "google_compute_subnetwork" "sub" {
  name    = "primary-sub"
  network = google_compute_network.vpc.id
}
