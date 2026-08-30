terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "3.96.4"
    }
  }
}

resource "newrelic_account_management" "platform" {
  name = "platform"
}

resource "newrelic_browser_application" "frontend" {
  name = "frontend"
}

resource "newrelic_fleet" "production" {
  name                = "production"
  managed_entity_type = "KUBERNETESCLUSTER"
}

resource "newrelic_synthetics_private_location" "private" {
  name        = "private"
  description = "private execution"
}
