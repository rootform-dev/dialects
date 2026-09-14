concept "secret-manager-secret-version" {
  description = "A version attached to a Secret Manager secret without exposing its secret data."
}

rule "secret-manager-secret" {
  match {
    type = "google_secret_manager_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "secret-manager-secret-version" {
  match {
    type = "google_secret_manager_secret_version"
  }

  as = concept.secret-manager-secret-version

  contribution {
    to  = concept.managed-secret
    via = source.secret
  }
}

rule "secret-manager-regional-secret" {
  match {
    type = "google_secret_manager_regional_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "secret-manager-regional-secret-version" {
  match {
    type = "google_secret_manager_regional_secret_version"
  }

  as = concept.secret-manager-secret-version

  contribution {
    to  = concept.managed-secret
    via = source.secret
  }
}
