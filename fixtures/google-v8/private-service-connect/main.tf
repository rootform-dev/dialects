terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

resource "google_sql_database_instance" "database" {
  name = "database"

  settings {
    tier = "db-custom-2-7680"

    ip_configuration {
      psc_config {
        psc_enabled = true
      }
    }
  }
}
