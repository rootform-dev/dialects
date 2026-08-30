terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_service_account" "workload" {
  account_id = "workload"
}

resource "google_project_iam_member" "viewer" {
  project = "example"
  role    = "roles/viewer"
  member  = google_service_account.workload.email
}

resource "google_project_iam_binding" "editors" {
  project = "example"
  role    = "roles/editor"
  members = [google_service_account.workload.email]
}

resource "google_project_iam_policy" "authoritative" {
  project     = "example"
  policy_data = "{}"
}
