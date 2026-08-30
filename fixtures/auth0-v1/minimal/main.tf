terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.56.0"
    }
  }
}

resource "auth0_tenant" "primary" {}

resource "auth0_client" "portal" {
  name = "portal"
}

resource "auth0_resource_server" "api" {
  identifier = "https://api.example.invalid"
}

resource "auth0_connection" "workforce" {
  name     = "workforce"
  strategy = "oidc"
}
