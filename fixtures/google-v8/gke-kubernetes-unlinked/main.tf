terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.38.0"
    }
  }
}

resource "google_container_cluster" "cluster" {
  name = "cluster"
}

resource "kubernetes_namespace_v1" "workloads" {
  metadata {
    name = "workloads"
  }
}
