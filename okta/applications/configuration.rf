concept "application-configuration" {
  description = "Claims, features, redirects, scopes, or access policy supporting an app integration."
}

rule "app-access-policy-assignment" {
  match {
    type = "okta_app_access_policy_assignment"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-features" {
  match {
    type = "okta_app_features"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-features-lookup" {
  match {
    kind = "data"
    type = "okta_app_features"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-federated-claim" {
  match {
    type = "okta_app_federated_claim"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-federated-claim-lookup" {
  match {
    kind = "data"
    type = "okta_app_federated_claim"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-oauth-api-scope" {
  match {
    type = "okta_app_oauth_api_scope"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-oauth-post-logout-redirect-uri" {
  match {
    type = "okta_app_oauth_post_logout_redirect_uri"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-oauth-redirect-uri" {
  match {
    type = "okta_app_oauth_redirect_uri"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-saml-app-settings" {
  match {
    type = "okta_app_saml_app_settings"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.app_id
  }
}

rule "app-sign-on-policy-rule-lookup" {
  match {
    kind = "data"
    type = "okta_app_sign_on_policy_rule"
  }

  as = concept.application-configuration
}

rule "app-signon-policy" {
  match {
    type = "okta_app_signon_policy"
  }

  as = concept.application-configuration
}

rule "app-signon-policy-lookup" {
  match {
    kind = "data"
    type = "okta_app_signon_policy"
  }

  as = concept.application-configuration
}

rule "app-signon-policy-rule" {
  match {
    type = "okta_app_signon_policy_rule"
  }

  as = concept.application-configuration
}
