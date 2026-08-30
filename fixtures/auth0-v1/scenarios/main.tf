terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "1.56.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
  }
}

resource "auth0_tenant" "primary" {}

data "auth0_tenant" "current" {}

resource "auth0_organization" "customer" {
  name = "customer"
}

data "auth0_organization" "customer" {}

resource "auth0_resource_server" "api" {
  identifier = "https://api.example.invalid"
}

data "auth0_resource_server" "api" {}

resource "auth0_client" "portal" {
  name                       = "portal"
  resource_server_identifier = auth0_resource_server.api.identifier

  default_organization {
    organization_id = auth0_organization.customer.id
  }
}

data "auth0_client" "portal" {}

resource "auth0_client_cimd" "partner" {
  name = "partner"
}

resource "auth0_client_credentials" "portal" {
  client_id = auth0_client.portal.id
}

resource "auth0_client_grant" "portal" {
  client_id = auth0_client.portal.id
  audience  = auth0_resource_server.api.identifier
}

resource "auth0_resource_server_scope" "read" {
  resource_server_identifier = auth0_resource_server.api.identifier
  scope                      = "read"
}

resource "auth0_resource_server_scopes" "all" {
  resource_server_identifier = auth0_resource_server.api.identifier
}

resource "auth0_connection" "workforce" {
  name     = "workforce"
  strategy = "oidc"
}

data "auth0_connection" "workforce" {}

resource "auth0_connection_client" "portal" {
  connection_id = auth0_connection.workforce.id
  client_id     = auth0_client.portal.id
}

resource "auth0_connection_clients" "portal" {
  connection_id = auth0_connection.workforce.id
}

resource "auth0_connection_directory" "directory" {
  connection_id = auth0_connection.workforce.id
}

data "auth0_connection_directory" "directory" {}

resource "auth0_connection_directory_synchronized_groups" "groups" {
  connection_id = auth0_connection_directory.directory.id
}

data "auth0_connection_directory_synchronized_groups" "groups" {
  connection_id = auth0_connection_directory.directory.id
}

resource "auth0_connection_keys" "keys" {
  connection_id = auth0_connection.workforce.id
}

data "auth0_connection_keys" "keys" {
  connection_id = auth0_connection.workforce.id
}

resource "auth0_connection_scim_configuration" "scim" {
  connection_id = auth0_connection.workforce.id
}

data "auth0_connection_scim_configuration" "scim" {
  connection_id = auth0_connection.workforce.id
}

resource "auth0_connection_profile" "enterprise" {}

data "auth0_connection_profile" "enterprise" {}

resource "auth0_self_service_profile" "enterprise" {}

data "auth0_self_service_profile" "enterprise" {}

resource "auth0_user_attribute_profile" "enterprise" {}

data "auth0_user_attribute_profile" "enterprise" {}

resource "auth0_custom_domain" "login" {
  domain = "login.example.invalid"
  type   = "auth0_managed_certs"
}

data "auth0_custom_domain" "login" {}

resource "auth0_custom_domain_default" "login" {
  domain = auth0_custom_domain.login.domain
}

resource "auth0_custom_domain_verification" "login" {
  custom_domain_id = auth0_custom_domain.login.id
}

resource "auth0_action" "normalize" {
  name = "normalize"
}

data "auth0_action" "normalize" {}

resource "auth0_action_module" "shared" {}

data "auth0_action_module" "shared" {}

resource "auth0_rule" "legacy" {
  name = "legacy"
}

resource "auth0_hook" "credentials_exchange" {
  name = "credentials-exchange"
}

resource "auth0_trigger_action" "normalize" {
  action_id = auth0_action.normalize.id
  trigger   = "post-login"
}

resource "auth0_trigger_actions" "login" {
  trigger = "post-login"
}

resource "auth0_token_exchange_profile" "partner" {
  name      = "partner"
  action_id = auth0_action.normalize.id
}

data "auth0_token_exchange_profile" "partner" {}

resource "auth0_flow" "onboarding" {
  name = "onboarding"
}

data "auth0_flow" "onboarding" {}

resource "auth0_form" "profile" {
  name = "profile"
}

data "auth0_form" "profile" {}

resource "auth0_flow_vault_connection" "crm" {
  name   = "crm"
  app_id = "crm"
}

data "auth0_flow_vault_connection" "crm" {}

resource "aws_cloudwatch_event_bus" "audit" {
  name = "auth0-audit"
}

resource "auth0_event_stream" "lifecycle" {
  name             = "lifecycle"
  destination_type = "action"
  subscriptions    = ["user.created"]

  action_configuration {
    action_id = auth0_action.normalize.id
  }

  depends_on = [aws_cloudwatch_event_bus.audit]
}

data "auth0_event_stream" "lifecycle" {}

resource "auth0_log_stream" "security" {
  name = "security"
  type = "eventbridge"
}

resource "auth0_network_acl" "authentication" {
  active      = true
  description = "authentication boundary"
  priority    = 1
}

data "auth0_network_acl" "authentication" {}

resource "auth0_attack_protection" "tenant" {}

data "auth0_attack_protection" "tenant" {}

resource "auth0_guardian" "mfa" {
  policy = "all-applications"
}

resource "auth0_risk_assessments" "tenant" {
  enabled = true
}

resource "auth0_risk_assessments_new_device" "tenant" {}

resource "auth0_supplemental_signals" "tenant" {}

resource "auth0_encryption_key_manager" "tenant" {}

resource "auth0_rate_limit_policy" "portal" {}

data "auth0_rate_limit_policy" "portal" {}

resource "auth0_email_provider" "transactional" {
  default_from_address = "identity@example.invalid"
  name                 = "smtp"
}

resource "auth0_phone_provider" "transactional" {
  name = "twilio"
}

data "auth0_phone_provider" "transactional" {}

resource "auth0_organization_client" "portal" {
  organization_id = auth0_organization.customer.id
  client_id       = auth0_client.portal.id
}

data "auth0_organization_client" "portal" {
  organization_id = auth0_organization.customer.id
  client_id       = auth0_client.portal.id
}

resource "auth0_organization_client_grant" "portal" {
  organization_id = auth0_organization.customer.id
  grant_id        = "grant"
}

resource "auth0_organization_clients" "all" {
  organization_id = auth0_organization.customer.id
}

resource "auth0_organization_connection" "workforce" {
  organization_id = auth0_organization.customer.id
  connection_id   = auth0_connection.workforce.id
}

resource "auth0_organization_connections" "workforce" {
  organization_id = auth0_organization.customer.id
}

resource "auth0_organization_discovery_domain" "customer" {
  organization_id = auth0_organization.customer.id
  domain           = "customer.example.invalid"
}

resource "auth0_organization_discovery_domains" "customer" {
  organization_id = auth0_organization.customer.id
}

resource "auth0_user" "must_not_create_topology" {
  email = "identity-user@example.invalid"
}

resource "auth0_role" "must_not_create_topology" {
  name = "reader"
}

resource "auth0_branding" "must_not_create_topology" {}
