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

resource "google_compute_subnetwork" "sub" {
  name    = "primary-sub"
  network = google_compute_network.vpc.id
}

resource "google_container_cluster" "cluster" {
  name       = "workloads"
  project    = google_project.platform.project_id
  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.sub.id
}

resource "google_container_cluster" "provider_default_project" {
  name = "provider-default-project"
}

resource "google_container_node_pool" "pool" {
  name    = "default-pool"
  cluster = google_container_cluster.cluster.id
}
