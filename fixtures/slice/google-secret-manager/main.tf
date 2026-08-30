terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_secret_manager_secret" "api" {
  secret_id = "api"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "api" {
  secret      = google_secret_manager_secret.api.id
  secret_data = "ROOTFORM_GOOGLE_SECRET_SENTINEL"
}
