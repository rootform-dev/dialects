terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "7.0.0"
    }
  }
}

resource "okta_org_configuration" "primary" {
  company_name = "Rootform"
}

resource "okta_app_oauth" "frontend" {
  label = "frontend"
  type  = "web"
}

resource "okta_auth_server" "api" {
  name      = "api"
  audiences = ["api"]
}

resource "okta_idp_oidc" "workforce" {
  name = "workforce"
}

resource "okta_event_hook" "audit" {
  name   = "audit"
  events = ["user.lifecycle.create"]
}
