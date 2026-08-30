terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_pubsub_topic" "events" {
  name = "events"
}

resource "google_pubsub_subscription" "worker" {
  name  = "worker"
  topic = google_pubsub_topic.events.id
}
