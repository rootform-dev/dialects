concept "certificate-authority" {
  description = "A Vault-managed or integrated certificate authority and issuer boundary."
}

concept "external-ca-integration" {
  description = "A Vault PKI integration delegating certificate issuance to an external authority."
}

concept "kmip-listener" {
  description = "A Vault KMIP protocol listener serving key-management clients."
}

concept "kmip-scope" {
  description = "An isolated Vault KMIP tenancy scope containing roles and managed objects."
}

concept "pki-configuration" {
  description = "A role, protocol, revocation, issuer, or lifecycle setting supporting Vault PKI or KMIP."
}

rule "kmip-secret-ca-generated" {
  match {
    type = "vault_kmip_secret_ca_generated"
  }

  as = concept.certificate-authority

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "kmip-secret-ca-imported" {
  match {
    type = "vault_kmip_secret_ca_imported"
  }

  as = concept.certificate-authority

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "kmip-secret-listener" {
  match {
    type = "vault_kmip_secret_listener"
  }

  as = concept.kmip-listener

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "kmip-secret-role" {
  match {
    type = "vault_kmip_secret_role"
  }

  as = concept.pki-configuration
}

rule "kmip-secret-scope" {
  match {
    type = "vault_kmip_secret_scope"
  }

  as = concept.kmip-scope

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "pki-external-ca-secret-backend-role" {
  match {
    type = "vault_pki_external_ca_secret_backend_role"
  }

  as = concept.external-ca-integration

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "pki-secret-backend-config-acme" {
  match {
    type = "vault_pki_secret_backend_config_acme"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-auto-tidy" {
  match {
    type = "vault_pki_secret_backend_config_auto_tidy"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-cluster" {
  match {
    type = "vault_pki_secret_backend_config_cluster"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-cmpv2" {
  match {
    type = "vault_pki_secret_backend_config_cmpv2"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-est" {
  match {
    type = "vault_pki_secret_backend_config_est"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-issuers" {
  match {
    type = "vault_pki_secret_backend_config_issuers"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-scep" {
  match {
    type = "vault_pki_secret_backend_config_scep"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-config-urls" {
  match {
    type = "vault_pki_secret_backend_config_urls"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-crl-config" {
  match {
    type = "vault_pki_secret_backend_crl_config"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-intermediate-set-signed" {
  match {
    type = "vault_pki_secret_backend_intermediate_set_signed"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-issuer" {
  match {
    type = "vault_pki_secret_backend_issuer"
  }

  as = concept.certificate-authority

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "pki-secret-backend-key" {
  match {
    type = "vault_pki_secret_backend_key"
  }

  as = concept.encryption-key

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "pki-secret-backend-role" {
  match {
    type = "vault_pki_secret_backend_role"
  }

  as = concept.pki-configuration

  contribution {
    to  = concept.secrets-engine
    via = source.backend
  }
}

rule "pki-secret-backend-root-cert" {
  match {
    type = "vault_pki_secret_backend_root_cert"
  }

  as = concept.certificate-authority

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "ssh-secret-backend-ca" {
  match {
    type = "vault_ssh_secret_backend_ca"
  }

  as = concept.certificate-authority

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}
