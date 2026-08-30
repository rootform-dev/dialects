terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_compute_backend_service" "backend" {
  name = "backend"
}

resource "google_compute_url_map" "map" {
  name            = "map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_https_proxy" "proxy" {
  name    = "proxy"
  url_map = google_compute_url_map.map.id
}

resource "google_compute_global_forwarding_rule" "frontend" {
  name                  = "frontend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_https_proxy.proxy.id
}
