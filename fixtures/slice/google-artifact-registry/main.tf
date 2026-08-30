terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_artifact_registry_repository" "applications" {
  location      = "europe-west1"
  repository_id = "applications"
  format        = "DOCKER"
}
