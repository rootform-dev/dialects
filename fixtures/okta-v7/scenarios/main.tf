terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "7.0.0"
    }
  }
}

provider "okta" {
  api_token = "ROOTFORM_OKTA_PROVIDER_TOKEN_SENTINEL"
  org_name  = "rootform-example"
}

resource "okta_api_service_integration" "api_service_integration" {

}

data "okta_api_service_integration" "api_service_integration" {

}

resource "okta_app_access_policy_assignment" "app_access_policy_assignment" {
  app_id = okta_app_oauth.oauth.id
}

resource "okta_app_auto_login" "app_auto_login" {

}

resource "okta_app_basic_auth" "app_basic_auth" {

}

resource "okta_app_bookmark" "app_bookmark" {

}

resource "okta_app_connection" "app_connection" {

}

data "okta_app_connection" "app_connection" {

}

resource "okta_app_features" "app_features" {
  app_id = okta_app_oauth.oauth.id
}

data "okta_app_features" "app_features" {
  app_id = okta_app_oauth.oauth.id
}

resource "okta_app_federated_claim" "app_federated_claim" {
  app_id = okta_app_oauth.oauth.id
}

data "okta_app_federated_claim" "app_federated_claim" {
  app_id = okta_app_oauth.oauth.id
}

data "okta_app" "app" {

}

resource "okta_app_oauth" "oauth" {
  client_basic_secret = "ROOTFORM_OKTA_APP_SECRET_SENTINEL"
}

resource "okta_app_oauth_api_scope" "app_oauth_api_scope" {
  app_id = okta_app_oauth.oauth.id
}

data "okta_app_oauth" "app_oauth" {

}

resource "okta_app_oauth_post_logout_redirect_uri" "app_oauth_post_logout_redirect_uri" {
  app_id = okta_app_oauth.oauth.id
}

resource "okta_app_oauth_redirect_uri" "app_oauth_redirect_uri" {
  app_id = okta_app_oauth.oauth.id
}

resource "okta_app_saml" "portal" {
  inline_hook_id = okta_inline_hook.token.id
}

resource "okta_app_saml_app_settings" "app_saml_app_settings" {
  app_id = okta_app_oauth.oauth.id
}

data "okta_app_saml" "app_saml" {

}

resource "okta_app_secure_password_store" "app_secure_password_store" {

}

resource "okta_app_shared_credentials" "app_shared_credentials" {

}

data "okta_app_sign_on_policy_rule" "app_sign_on_policy_rule" {

}

resource "okta_app_signon_policy" "app_signon_policy" {

}

data "okta_app_signon_policy" "app_signon_policy" {

}

resource "okta_app_signon_policy_rule" "app_signon_policy_rule" {

}

resource "okta_app_swa" "app_swa" {

}

resource "okta_app_three_field" "app_three_field" {

}

resource "okta_auth_server" "api" {

}

resource "okta_auth_server_claim" "auth_server_claim" {
  auth_server_id = okta_auth_server.api.id
}

resource "okta_auth_server_claim_default" "auth_server_claim_default" {
  auth_server_id = okta_auth_server.api.id
}

data "okta_auth_server_claim" "auth_server_claim" {
  auth_server_id = okta_auth_server.api.id
}

resource "okta_auth_server_default" "auth_server_default" {

}

data "okta_auth_server" "auth_server" {

}

resource "okta_auth_server_policy" "auth_server_policy" {
  auth_server_id = okta_auth_server.api.id
}

data "okta_auth_server_policy" "auth_server_policy" {
  auth_server_id = okta_auth_server.api.id
}

resource "okta_auth_server_policy_rule" "auth_server_policy_rule" {
  auth_server_id = okta_auth_server.api.id
  inline_hook_id = okta_inline_hook.token.id
}

resource "okta_auth_server_scope" "read" {
  auth_server_id = okta_auth_server.api.id
}

resource "okta_authenticator" "primary" {

}

data "okta_authenticator" "authenticator" {

}

resource "okta_authenticator_method_webauthn" "authenticator_method_webauthn" {
  authenticator_id = okta_authenticator.primary.id
}

data "okta_authenticator_method_webauthn" "authenticator_method_webauthn" {
  authenticator_id = okta_authenticator.primary.id
}

resource "okta_authenticator_webauthn_custom_aaguid" "authenticator_webauthn_custom_aaguid" {
  authenticator_id = okta_authenticator.primary.id
}

data "okta_authenticator_webauthn_custom_aaguids" "authenticator_webauthn_custom_aaguids" {

}

resource "okta_behavior" "behavior" {

}

data "okta_behavior" "behavior" {

}

resource "okta_captcha" "captcha" {

}

data "okta_captcha" "captcha" {

}

resource "okta_domain" "login" {

}

resource "okta_domain_certificate" "domain_certificate" {
  domain_id = okta_domain.login.id
  private_key = "ROOTFORM_OKTA_DOMAIN_PRIVATE_KEY_SENTINEL"
}

data "okta_domain" "domain" {

}

resource "okta_domain_verification" "login" {
  domain_id = okta_domain.login.id
}

resource "okta_event_hook" "events" {
  headers {
    key   = "Authorization"
    value = "ROOTFORM_OKTA_HOOK_HEADER_SENTINEL"
  }
}

resource "okta_event_hook_verification" "event_hook_verification" {
  event_hook_id = okta_event_hook.events.id
}

resource "okta_hook_key" "hook_key" {

}

data "okta_hook_key" "hook_key" {

}

resource "okta_idp_oidc" "idp_oidc" {
  client_secret = "ROOTFORM_OKTA_IDP_SECRET_SENTINEL"
}

data "okta_idp_oidc" "idp_oidc" {

}

resource "okta_idp_saml" "idp_saml" {

}

data "okta_idp_saml" "idp_saml" {

}

resource "okta_idp_social" "idp_social" {

}

data "okta_idp_social" "idp_social" {

}

resource "okta_inline_hook" "token" {

}

resource "okta_log_stream" "log_stream" {
  settings {
    token = "ROOTFORM_OKTA_LOG_TOKEN_SENTINEL"
  }
}

data "okta_log_stream" "log_stream" {

}

resource "okta_network_zone" "network_zone" {

}

data "okta_network_zone" "network_zone" {

}

data "okta_oauth_authorization_server" "oauth_authorization_server" {

}

resource "okta_org_captcha" "org_captcha" {

}

data "okta_org_captcha" "org_captcha" {

}

resource "okta_org_configuration" "primary" {

}

data "okta_org_metadata" "org_metadata" {

}

resource "okta_policy_rule_idp_discovery" "routing" {

}

resource "okta_realm" "customers" {

}

resource "okta_realm_assignment" "realm_assignment" {
  realm_id = okta_realm.customers.id
}

data "okta_realm_assignment" "realm_assignment" {
  realm_id = okta_realm.customers.id
}

data "okta_realm" "realm" {

}

resource "okta_security_events_provider" "security_events_provider" {

}

data "okta_security_events_provider" "security_events_provider" {

}

resource "okta_threat_insight_settings" "threat_insight_settings" {

}

data "okta_threat_insight_settings" "threat_insight_settings" {

}

resource "okta_trusted_origin" "trusted_origin" {

}

data "okta_trusted_origin" "trusted_origin" {

}

resource "okta_trusted_server" "trusted_server" {
  auth_server_id = okta_auth_server.api.id
}

resource "okta_user" "must_not_create_topology" {
  first_name = "Rootform"
  last_name  = "Sentinel"
  login      = "sentinel@example.invalid"
  email      = "sentinel@example.invalid"
  profile = jsonencode({ private = "ROOTFORM_OKTA_USER_PROFILE_SENTINEL" })
}
