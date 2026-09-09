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

resource "google_secret_manager_secret" "api" {
  secret_id = "api"
  project   = google_project.platform.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "provider_default_project" {
  secret_id = "provider-default-project"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "api" {
  secret      = google_secret_manager_secret.api.id
  secret_data = "ROOTFORM_GOOGLE_SECRET_SENTINEL"
}
