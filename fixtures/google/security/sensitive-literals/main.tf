terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

variable "private_key" {
  sensitive = true
}

resource "google_compute_ssl_certificate" "cert" {
  name        = "sensitive-cert"
  certificate = "SECRET_SSL_CERTIFICATE_31a"
  private_key = var.private_key
}

resource "google_project_iam_policy" "policy" {
  project     = "SECRET_PROJECT_ID_31c"
  policy_data = "SECRET_POLICY_DATA_31d"
}

resource "google_project_iam_member" "member" {
  project = "SECRET_PROJECT_ID_31e"
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:SECRET_MEMBER_LITERAL_31f@example.com"
}

resource "google_sql_database_instance" "db" {
  name             = "sensitive-db"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    ip_configuration {
      require_ssl = true
    }
  }
}
