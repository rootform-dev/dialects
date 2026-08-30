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

resource "google_container_cluster" "cluster" {
  name       = "workloads"
  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.sub.id
}

resource "google_container_node_pool" "pool" {
  name    = "default-pool"
  cluster = google_container_cluster.cluster.id
}
