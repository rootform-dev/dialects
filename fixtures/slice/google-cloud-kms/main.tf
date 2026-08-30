terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_kms_key_ring" "application" {
  name     = "application"
  location = "europe-west1"
}

resource "google_kms_crypto_key" "application" {
  name     = "application"
  key_ring = google_kms_key_ring.application.id
}

resource "google_kms_crypto_key_version" "application" {
  crypto_key = google_kms_crypto_key.application.id
}
