terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

variable "unknown_project" { type = string }
variable "unknown_connector" { type = string }
variable "unknown_service_account" { type = string }

resource "google_project" "platform" {
  name       = "platform"
  project_id = "demo-project"
}

resource "google_project" "duplicate_a" {
  name       = "duplicate-a"
  project_id = "duplicate-project"
}

resource "google_project" "duplicate_b" {
  name       = "duplicate-b"
  project_id = "duplicate-project"
}

resource "google_compute_network" "runtime" {
  name = "runtime"
}

resource "google_compute_subnetwork" "runtime" {
  name          = "runtime"
  region        = "europe-west1"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.runtime.id
}

resource "google_service_account" "runtime" {
  account_id = "runtime"
  project    = google_project.platform.project_id
}

resource "google_vpc_access_connector" "runtime" {
  name   = "runtime"
  region = "europe-west1"

  subnet {
    name = google_compute_subnetwork.runtime.name
  }
}

resource "google_cloud_run_v2_service" "api" {
  name     = "api"
  location = "europe-west1"
  project  = google_project.platform.project_id

  template {
    service_account = google_service_account.runtime.email

    containers {
      image = "europe-west1-docker.pkg.dev/example/apps/api:stable"
    }

    vpc_access {
      network_interfaces {
        network    = google_compute_network.runtime.id
        subnetwork = google_compute_subnetwork.runtime.id
      }
    }
  }
}

resource "google_cloud_run_v2_service" "connector" {
  name     = "connector"
  location = "europe-west1"
  project  = google_project.platform.project_id

  template {
    service_account = google_service_account.runtime.email

    containers {
      image = "europe-west1-docker.pkg.dev/example/apps/connector:stable"
    }

    vpc_access {
      connector = google_vpc_access_connector.runtime.id
    }
  }
}

resource "google_cloud_run_v2_service" "literal" {
  name     = "literal"
  location = "europe-west1"
  project  = "duplicate-project"

  template {
    service_account = "runtime@demo-project.iam.gserviceaccount.com"
    containers { image = "example.invalid/literal" }
    vpc_access { connector = "projects/demo/locations/europe-west1/connectors/runtime" }
  }
}

resource "google_cloud_run_v2_service" "unknown" {
  name     = "unknown"
  location = "europe-west1"
  project  = var.unknown_project

  template {
    service_account = var.unknown_service_account
    containers { image = "example.invalid/unknown" }
    vpc_access { connector = var.unknown_connector }
  }
}

resource "google_cloud_run_v2_job" "migration" {
  name     = "migration"
  location = "europe-west1"

  template {
    template {
      containers {
        image = "europe-west1-docker.pkg.dev/example/apps/migration:stable"
      }
    }
  }
}
