concept "secrets-store" {
  description = "A Cloudflare Secrets Store boundary."
}

rule "oauth-client" {
  match {
    type = "cloudflare_oauth_client"
  }

  as = rf.concept.service-identity
}

rule "sso-connector" {
  match {
    type = "cloudflare_sso_connector"
  }

  as = concept.identity-provider
}


rule "secrets-store" {
  match {
    type = "cloudflare_secrets_store"
  }

  as = concept.secrets-store
}

rule "secrets-store-secret" {
  match {
    type = "cloudflare_secrets_store_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.secrets-store
    via = source.store_id
  }
}
