concept "service-credential" {
  description = "A credential issued for a service identity."
}

rule "iam-service-account" {
  match {
    type = "google_service_account"
  }

  as = rf.concept.service-identity

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "service-account-key" {
  match {
    type = "google_service_account_key"
  }

  as = concept.service-credential

  contribution {
    to  = rf.concept.service-identity
    via = source.service_account_id
  }
}
