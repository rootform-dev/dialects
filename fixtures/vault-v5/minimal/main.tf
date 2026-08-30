terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
  }
}

resource "vault_namespace" "platform" {
  path = "platform"
}

resource "vault_namespace" "security" {
  namespace = vault_namespace.platform.path
  path      = "security"
}

resource "vault_mount" "database" {
  namespace = vault_namespace.security.path
  path      = "database"
  type      = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend = vault_mount.database.path
  name    = "postgres"
}

resource "vault_identity_entity" "application" {
  namespace = vault_namespace.security.path
  name      = "application"
}

resource "vault_identity_group" "platform" {
  namespace = vault_namespace.security.path
  name      = "platform"
  type      = "internal"
}
