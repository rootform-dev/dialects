terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = "demo-project"
  region  = "us-central1"
}

resource "google_compute_network" "vpc" {
  name = "demo-vpc"
}

resource "google_container_cluster" "primary" {
  name     = "demo-cluster"
  location = "us-central1"
  network  = google_compute_network.vpc.id

  initial_node_count = 1
}

provider "kubernetes" {
  host  = google_container_cluster.primary.endpoint
  token = "rootform-fixture-service-account-token"
}

resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = "app"
  }
}

resource "kubernetes_service_account_v1" "app" {
  metadata {
    name      = "app"
    namespace = "app"
  }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "app"
    namespace = "app"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "app"
      }
    }

    template {
      metadata {
        labels = {
          app = "app"
        }
      }

      spec {
        container {
          name  = "app"
          image = "registry.example.com/app:0.1.0"
        }
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "db" {
  metadata {
    name      = "db"
    namespace = "app"
  }

  spec {
    service_name = "db"

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        container {
          name  = "db"
          image = "registry.example.com/db:0.1.0"
        }
      }
    }
  }
}

resource "kubernetes_daemon_set_v1" "collector" {
  metadata {
    name      = "collector"
    namespace = "app"
  }

  spec {
    selector {
      match_labels = {
        app = "collector"
      }
    }

    template {
      metadata {
        labels = {
          app = "collector"
        }
      }

      spec {
        container {
          name  = "collector"
          image = "registry.example.com/collector:0.1.0"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name      = "app"
    namespace = "app"
  }

  spec {
    selector = {
      app = "app"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "app"
    namespace = "app"
  }

  spec {
    rule {
      http {
        path {
          path = "/"

          backend {
            service {
              name = "app"

              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "data" {
  metadata {
    name      = "data"
    namespace = "app"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "app" {
  metadata {
    name      = "app"
    namespace = "app"
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = "app"
    }

    min_replicas = 1
    max_replicas = 5
  }
}
