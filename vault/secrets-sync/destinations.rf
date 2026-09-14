concept "secret-sync-configuration" {
  description = "A destination association or service setting supporting Vault Secrets Sync."
}

concept "secret-sync-destination" {
  description = "An external cloud or SaaS destination receiving secrets through Vault Secrets Sync."
}

rule "secrets-sync-association" {
  match {
    type = "vault_secrets_sync_association"
  }

  as = concept.secret-sync-configuration

  contribution {
    to  = concept.secret-sync-destination
    via = source.name
  }
}

rule "secrets-sync-aws-destination" {
  match {
    type = "vault_secrets_sync_aws_destination"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.kms_key_id
  }
}

rule "secrets-sync-azure-destination" {
  match {
    type = "vault_secrets_sync_azure_destination"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.client_id
  }
}

rule "secrets-sync-config" {
  match {
    type = "vault_secrets_sync_config"
  }

  as = concept.secret-sync-configuration
}

rule "secrets-sync-gcp-destination" {
  match {
    type = "vault_secrets_sync_gcp_destination"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.service_account_email
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.kms_key_id
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.global_kms_key
  }
}

rule "secrets-sync-gh-destination" {
  match {
    type = "vault_secrets_sync_gh_destination"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "secrets-sync-github-apps" {
  match {
    type = "vault_secrets_sync_github_apps"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "secrets-sync-vercel-destination" {
  match {
    type = "vault_secrets_sync_vercel_destination"
  }

  as = concept.secret-sync-destination

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}
