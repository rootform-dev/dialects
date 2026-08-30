terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

variable "db_password" {
  sensitive = true
}

variable "project" {
  type = string
}

resource "google_sql_database_instance" "db" {
  name             = "tfvars-db"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    user_labels = {
      env = var.project
    }
  }
}
