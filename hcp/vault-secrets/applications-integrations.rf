concept "vault-secrets-application" {
  description = "An HCP Vault Secrets application boundary grouping secrets and sync destinations."
}

concept "vault-secrets-configuration" {
  description = "A secret read or access setting supporting an HCP Vault Secrets application."
}

concept "vault-secrets-integration" {
  description = "An HCP Vault Secrets integration with an external cloud or SaaS platform."
}

concept "vault-secrets-sync" {
  description = "An HCP Vault Secrets destination synchronizing application secrets externally."
}

rule "vault-secrets-app" {
  match {
    type = "hcp_vault_secrets_app"
  }

  as = concept.vault-secrets-application

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "syncs-to" {
    to  = concept.vault-secrets-sync
    via = source.sync_names
  }
}

rule "vault-secrets-app-iam-binding" {
  match {
    type = "hcp_vault_secrets_app_iam_binding"
  }

  as = concept.vault-secrets-configuration

  contribution {
    to  = concept.vault-secrets-application
    via = source.resource_name
  }
}

rule "vault-secrets-app-iam-policy" {
  match {
    type = "hcp_vault_secrets_app_iam_policy"
  }

  as = concept.vault-secrets-configuration

  contribution {
    to  = concept.vault-secrets-application
    via = source.resource_name
  }
}

rule "vault-secrets-app-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_secrets_app"
  }

  as = concept.vault-secrets-application

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "vault-secrets-dynamic-secret" {
  match {
    type = "hcp_vault_secrets_dynamic_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.vault-secrets-application
    via = source.app_name
  }

  relation "uses-integration" {
    to  = concept.vault-secrets-integration
    via = source.integration_name
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp_impersonate_service_account.service_account_email
  }
}

rule "vault-secrets-dynamic-secret-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_secrets_dynamic_secret"
  }

  as = concept.vault-secrets-configuration

  contribution {
    to  = concept.vault-secrets-application
    via = source.app_name
  }
}

rule "vault-secrets-integration" {
  match {
    type = "hcp_vault_secrets_integration"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.azure_federated_workload_identity.client_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp_federated_workload_identity.service_account_email
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp_service_account_key.client_email
  }
}

rule "vault-secrets-integration-aws" {
  match {
    type = "hcp_vault_secrets_integration_aws"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

}

rule "vault-secrets-integration-azure" {
  match {
    type = "hcp_vault_secrets_integration_azure"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.federated_workload_identity.client_id
  }
}

rule "vault-secrets-integration-confluent" {
  match {
    type = "hcp_vault_secrets_integration_confluent"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "vault-secrets-integration-gcp" {
  match {
    type = "hcp_vault_secrets_integration_gcp"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.federated_workload_identity.service_account_email
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.service_account_key.client_email
  }
}

rule "vault-secrets-integration-mongodbatlas" {
  match {
    type = "hcp_vault_secrets_integration_mongodbatlas"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "vault-secrets-integration-twilio" {
  match {
    type = "hcp_vault_secrets_integration_twilio"
  }

  as = concept.vault-secrets-integration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "vault-secrets-rotating-secret" {
  match {
    type = "hcp_vault_secrets_rotating_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.vault-secrets-application
    via = source.app_name
  }

  relation "uses-integration" {
    to  = concept.vault-secrets-integration
    via = source.integration_name
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.azure_application_password.app_client_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.confluent_service_account.service_account_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp_service_account_key.service_account_email
  }
}

rule "vault-secrets-rotating-secret-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_secrets_rotating_secret"
  }

  as = concept.vault-secrets-configuration

  contribution {
    to  = concept.vault-secrets-application
    via = source.app_name
  }
}

rule "vault-secrets-secret" {
  match {
    type = "hcp_vault_secrets_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.vault-secrets-application
    via = source.app_name
  }
}

rule "vault-secrets-secret-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_secrets_secret"
  }

  as = concept.vault-secrets-configuration

  contribution {
    to  = concept.vault-secrets-application
    via = source.app_name
  }
}

rule "vault-secrets-sync" {
  match {
    type = "hcp_vault_secrets_sync"
  }

  as = concept.vault-secrets-sync

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-integration" {
    to  = concept.vault-secrets-integration
    via = source.integration_name
  }
}
