terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "7.0.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

provider "okta" {
  api_token = "ROOTFORM_OKTA_BOUNDARY_SECRET_SENTINEL"
  org_name  = "rootform-example"
}

resource "okta_app_oauth" "first" {
  label = "first"
  type  = "web"
}

resource "okta_app_oauth" "second" {
  label = "second"
  type  = "web"
}

resource "okta_realm" "mismatch" {
  name = "mismatch"
}

resource "okta_app_features" "literal" {
  app_id     = "first"
  depends_on = [okta_app_oauth.first]
}

resource "okta_app_features" "ambiguous" {
  app_id = var.choose_first ? okta_app_oauth.first.id : okta_app_oauth.second.id
}

resource "okta_app_features" "dangling" {
  app_id = okta_app_oauth.missing.id
}

resource "okta_app_features" "mismatch" {
  app_id = okta_realm.mismatch.id
}

resource "okta_api_token" "private" {
  name  = "private"
  token = "ROOTFORM_OKTA_BOUNDARY_SECRET_SENTINEL"
}

resource "okta_user" "private" {
  first_name = "Rootform"
  last_name  = "Boundary"
  login      = "boundary@example.invalid"
  email      = "boundary@example.invalid"
  profile    = jsonencode({ private = "ROOTFORM_OKTA_BOUNDARY_PROFILE_SENTINEL" })
}
