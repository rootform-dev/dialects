resource "google_bigquery_dataset" "analytics" {
  dataset_id = "analytics"
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = "events"

  view {
    query          = "SELECT 'ROOTFORM_SQL_PAYLOAD_SENTINEL'"
    use_legacy_sql = false
  }
}

resource "google_bigquery_dataset_access" "reader" {
  dataset_id    = google_bigquery_dataset.analytics.dataset_id
  role          = "READER"
  user_by_email = "reader@example.invalid"
}

resource "google_bigquery_table_iam_member" "viewer" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = google_bigquery_table.events.table_id
  role       = "roles/bigquery.dataViewer"
  member     = "user:reader@example.invalid"
}

resource "google_storage_bucket" "archive" {
  name     = "rootform-synthetic-archive"
  location = "EU"

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }

    condition {
      age = 30
    }
  }
}

resource "google_storage_bucket_iam_member" "archive_reader" {
  bucket = google_storage_bucket.archive.name
  role   = "roles/storage.objectViewer"
  member = "user:reader@example.invalid"
}

resource "google_service_account" "automation" {
  account_id = "rootform-automation"
}

resource "google_service_account_key" "automation" {
  service_account_id = google_service_account.automation.name
}

resource "google_project_iam_member" "automation_viewer" {
  project = "rootform-synthetic"
  role    = "roles/viewer"
  member  = google_service_account.automation.email
}

resource "google_project_service" "bigquery" {
  project = "rootform-synthetic"
  service = "bigquery.googleapis.com"
}
