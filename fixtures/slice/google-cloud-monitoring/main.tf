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

resource "google_monitoring_alert_policy" "latency" {
  display_name = "API latency"
  combiner     = "OR"
  project      = google_project.platform.project_id

  conditions {
    display_name = "High request latency"

    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/request_latencies\""
      comparison      = "COMPARISON_GT"
      threshold_value = 2
      duration        = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "provider_default_project" {
  display_name = "Provider default project"
  combiner     = "OR"
  conditions {
    display_name = "Always false"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/request_count\""
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "300s"
    }
  }
}
