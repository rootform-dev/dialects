terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_dns_managed_zone" "public" {
  name     = "public"
  dns_name = "example.invalid."
}

resource "google_dns_record_set" "api" {
  managed_zone = google_dns_managed_zone.public.name
  name         = "api.example.invalid."
  type         = "A"
  ttl          = 300
  rrdatas      = ["192.0.2.10"]
}
