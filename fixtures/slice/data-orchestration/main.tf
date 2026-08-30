terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
    kestra = {
      source  = "kestra-io/kestra"
      version = ">= 0.22.0, < 1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0, < 4.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0.0, < 6.0.0"
    }
  }
}
