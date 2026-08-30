resource "google_bigquery_model" "forecast" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  model_id   = "forecast"
}

resource "kestra_tenant" "unsupported" {
  tenant_id = "unsupported"
}

resource "vault_mount" "configured" {
  path = "configured"
  type = "kv"
}

resource "random_id" "unsupported" {
  byte_length = 8
}
