terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
  }
}

variable "unknown_network" { type = string }
variable "unknown_project" { type = string }

resource "google_project" "platform" {
  name       = "platform"
  project_id = "demo-project"
}

resource "google_compute_network" "cache" {
  name = "cache"
}

resource "google_redis_instance" "redis" {
  name               = "redis"
  tier               = "BASIC"
  memory_size_gb     = 1
  authorized_network = google_compute_network.cache.id
  project            = google_project.platform.project_id
}

resource "google_memcache_instance" "memcache" {
  name               = "memcache"
  authorized_network = google_compute_network.cache.id
  project            = google_project.platform.project_id
  node_config {
    cpu_count      = 1
    memory_size_mb = 1024
  }
  node_count = 1
}

resource "google_redis_cluster" "cluster" {
  name          = "cluster"
  shard_count   = 3
  project       = google_project.platform.project_id
  region        = "us-central1"
  replica_count = 1
}

resource "google_redis_instance" "literal" {
  name               = "literal"
  tier               = "BASIC"
  memory_size_gb     = 1
  authorized_network = "cache"
  project            = "demo-project"
}

resource "google_redis_instance" "unknown" {
  name               = "unknown"
  tier               = "BASIC"
  memory_size_gb     = 1
  authorized_network = var.unknown_network
  project            = var.unknown_project
}

resource "google_redis_instance" "provider_default" {
  name           = "provider-default"
  tier           = "BASIC"
  memory_size_gb = 1
}
