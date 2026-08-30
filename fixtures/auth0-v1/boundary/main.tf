terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.56.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "auth0_client" "first" {
  name = "first"
}

resource "auth0_client" "second" {
  name = "second"
}

resource "auth0_organization" "mismatch" {
  name = "mismatch"
}

resource "auth0_connection" "workforce" {
  name     = "workforce"
  strategy = "oidc"
}

resource "auth0_action" "private" {
  name = "private"
  code = "ROOTFORM_AUTH0_ACTION_CODE_SENTINEL"
}

resource "auth0_event_stream" "literal" {
  name             = "literal"
  destination_type = "webhook"
  subscriptions    = ["user.created"]

  webhook_configuration {
    webhook_endpoint = "https://literal.invalid/ROOTFORM_AUTH0_URL_SENTINEL"
  }
}

resource "auth0_client_grant" "literal" {
  client_id  = "first"
  audience   = "https://literal.invalid"
  depends_on = [auth0_client.first]
}

resource "auth0_client_grant" "ambiguous" {
  client_id = var.choose_first ? auth0_client.first.id : auth0_client.second.id
  audience  = "https://literal.invalid"
}

resource "auth0_client_grant" "dangling" {
  client_id = auth0_client.missing.id
  audience  = "https://literal.invalid"
}

resource "auth0_client_grant" "mismatch" {
  client_id = auth0_organization.mismatch.id
  audience  = "https://literal.invalid"
}

resource "auth0_client_credentials" "private" {
  client_id     = "first"
  client_secret = "ROOTFORM_AUTH0_CLIENT_SECRET_SENTINEL"
}

resource "auth0_user" "private" {
  email         = "boundary@example.invalid"
  user_metadata = jsonencode({ private = "ROOTFORM_AUTH0_USER_SENTINEL" })
}
