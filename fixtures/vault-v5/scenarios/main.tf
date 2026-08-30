terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    google = {
      source = "hashicorp/google"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
  }
}

resource "aws_iam_role" "vault" {
  name = "rootform-vault"
}

resource "aws_kms_key" "vault" {
  description = "Vault test key"
}

resource "aws_s3_bucket" "snapshots" {
  bucket = "rootform-vault-snapshots"
}

resource "azurerm_resource_group" "vault" {
  name     = "rootform-vault"
  location = "West Europe"
}

resource "azurerm_storage_account" "vault" {
  name                = "rootformvault"
  resource_group_name = azurerm_resource_group.vault.name
  location            = azurerm_resource_group.vault.location
}

resource "azurerm_storage_container" "snapshots" {
  name               = "snapshots"
  storage_account_id = azurerm_storage_account.vault.id
}

resource "azurerm_user_assigned_identity" "vault" {
  name                = "rootform-vault"
  resource_group_name = azurerm_resource_group.vault.name
  location            = azurerm_resource_group.vault.location
}

resource "google_service_account" "vault" {
  account_id = "rootform-vault"
}

resource "google_storage_bucket" "snapshots" {
  name     = "rootform-vault-snapshots"
  location = "EU"
}

resource "google_kms_key_ring" "vault" {
  name     = "rootform-vault"
  location = "global"
}

resource "google_kms_crypto_key" "vault" {
  name     = "rootform-vault"
  key_ring = google_kms_key_ring.vault.id
}

resource "google_container_cluster" "security" {
  name     = "security"
  location = "europe-west1"
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

resource "vault_aws_secret_backend" "aws" {
  namespace = vault_namespace.security.path
  path      = "aws"
  role_arn  = aws_iam_role.vault.arn
}

resource "vault_gcp_secret_backend" "google" {
  namespace             = vault_namespace.security.path
  path                  = "gcp"
  service_account_email = google_service_account.vault.email
}

resource "vault_kubernetes_secret_backend" "kubernetes" {
  namespace       = vault_namespace.security.path
  path            = "kubernetes"
  kubernetes_host = google_container_cluster.security.endpoint
}

resource "vault_auth_backend" "kubernetes" {
  namespace = vault_namespace.security.path
  path      = "kubernetes"
  type      = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  namespace       = vault_namespace.security.path
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = google_container_cluster.security.endpoint
}

resource "vault_kubernetes_auth_backend_role" "applications" {
  backend   = vault_auth_backend.kubernetes.path
  role_name = "applications"
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

resource "vault_identity_oidc_key" "signing" {
  namespace = vault_namespace.security.path
  name      = "signing"
}

resource "vault_identity_oidc" "provider" {
  namespace = vault_namespace.security.path
  issuer    = "https://vault.rootform.invalid"
}

resource "vault_identity_oidc_provider" "provider" {
  namespace = vault_namespace.security.path
  name      = "rootform"
}

resource "vault_identity_oidc_client" "application" {
  namespace = vault_namespace.security.path
  name      = "application"
  key       = vault_identity_oidc_key.signing.name
}

resource "vault_pki_secret_backend_root_cert" "root" {
  namespace   = vault_namespace.security.path
  backend     = "pki"
  type        = "internal"
  common_name = "rootform.invalid"
}

resource "vault_pki_secret_backend_issuer" "root" {
  namespace   = vault_namespace.security.path
  backend     = "pki"
  issuer_ref  = vault_pki_secret_backend_root_cert.root.issuer_id
  issuer_name = "root"
}

resource "vault_pki_secret_backend_key" "issuing" {
  namespace = vault_namespace.security.path
  backend   = "pki"
  key_name  = "issuing"
  type      = "internal"
}

resource "vault_transit_secret_backend_key" "application" {
  namespace = vault_namespace.security.path
  backend   = "transit"
  name      = "application"
}

resource "vault_keymgmt_aws_kms" "aws" {
  namespace = vault_namespace.security.path
  name      = "aws"
}

resource "vault_secrets_sync_aws_destination" "aws" {
  namespace  = vault_namespace.security.path
  name       = "aws"
  role_arn   = aws_iam_role.vault.arn
  kms_key_id = aws_kms_key.vault.arn
}

resource "vault_secrets_sync_azure_destination" "azure" {
  namespace = vault_namespace.security.path
  name      = "azure"
  client_id = azurerm_user_assigned_identity.vault.client_id
}

resource "vault_secrets_sync_gcp_destination" "google" {
  namespace             = vault_namespace.security.path
  name                  = "google"
  service_account_email = google_service_account.vault.email
  kms_key_id            = google_kms_crypto_key.vault.id
}

resource "vault_secrets_sync_association" "aws" {
  name        = vault_secrets_sync_aws_destination.aws.name
  mount       = "kv"
  secret_name = "application"
}

resource "vault_raft_snapshot_agent_config" "continuity" {
  namespace            = vault_namespace.security.path
  name                 = "continuity"
  aws_s3_bucket        = aws_s3_bucket.snapshots.id
  aws_s3_kms_key       = aws_kms_key.vault.arn
  azure_container_name = azurerm_storage_container.snapshots.name
  google_gcs_bucket    = google_storage_bucket.snapshots.name
}

resource "vault_audit" "security" {
  namespace = vault_namespace.security.path
  type      = "file"
  path      = "security"
}

resource "vault_agent_registration" "workload" {
  namespace = vault_namespace.security.path
}

resource "vault_plugin_runtime" "external" {
  namespace = vault_namespace.security.path
  name      = "external"
  type      = "container"
}

resource "vault_generic_secret" "application" {
  namespace = vault_namespace.security.path
  path      = "kv/application"
  data_json = jsonencode({ password = "ROOTFORM_VAULT_SECRET_SENTINEL" })
}

data "vault_generic_secret" "application" {
  namespace = vault_namespace.security.path
  path      = vault_generic_secret.application.path
}
