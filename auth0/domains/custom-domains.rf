concept "domain-configuration" {
  description = "Default-domain or verification configuration supporting an Auth0 custom domain."
}

concept "identity-domain" {
  description = "A custom domain exposing an Auth0-hosted identity endpoint."
}

rule "custom-domain" {
  match {
    type = "auth0_custom_domain"
  }

  as = concept.identity-domain
}

rule "custom-domain-default" {
  match {
    type = "auth0_custom_domain_default"
  }

  as = concept.domain-configuration

  contribution {
    to  = concept.identity-domain
    via = source.domain
  }
}

rule "custom-domain-lookup" {
  match {
    kind = "data"
    type = "auth0_custom_domain"
  }

  as = concept.identity-domain
}

rule "custom-domain-verification" {
  match {
    type = "auth0_custom_domain_verification"
  }

  as = concept.domain-configuration

  contribution {
    to  = concept.identity-domain
    via = source.custom_domain_id
  }
}
