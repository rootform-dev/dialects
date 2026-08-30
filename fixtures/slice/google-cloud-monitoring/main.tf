terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_monitoring_alert_policy" "latency" {
  display_name = "API latency"
  combiner     = "OR"

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
