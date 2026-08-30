terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    google = {
      source = "hashicorp/google"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "3.96.4"
    }
  }
}

provider "newrelic" {
  api_key = "ROOTFORM_NEWRELIC_PROVIDER_KEY_SENTINEL"
}

resource "newrelic_account_management" "platform" {
  name = "platform"
}

data "newrelic_account" "platform" {
  account_id = newrelic_account_management.platform.id
}

resource "newrelic_browser_application" "frontend" {
  account_id = newrelic_account_management.platform.id
  name       = "frontend"
}

data "newrelic_application" "backend" {
  name = "backend"
}

resource "newrelic_application_settings" "backend" {
  guid = "backend-guid"
  name = "backend"
}

resource "newrelic_key_transaction" "checkout" {
  application_guid = "backend-guid"
  name             = "checkout"
}

data "newrelic_key_transaction" "checkout" {
  name = "checkout"
}

resource "aws_iam_role" "newrelic" {
  name = "newrelic-observability"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = []
  })
}

resource "google_service_account" "newrelic" {
  account_id = "newrelic-observability"
}

resource "newrelic_aws_connection" "ingest" {
  account_id = newrelic_account_management.platform.id
  name       = "federated-logs"
  credential {
    assume_role {
      role_arn = aws_iam_role.newrelic.arn
    }
  }
}

resource "newrelic_cloud_aws_link_account" "production" {
  account_id = newrelic_account_management.platform.id
  name       = "production"
  arn        = aws_iam_role.newrelic.arn
}

resource "newrelic_cloud_aws_govcloud_link_account" "government" {
  account_id = newrelic_account_management.platform.id
  name       = "government"
  arn        = aws_iam_role.newrelic.arn
}

resource "newrelic_cloud_aws_eu_sovereign_link_account" "sovereign" {
  account_id = newrelic_account_management.platform.id
  name       = "sovereign"
  arn        = aws_iam_role.newrelic.arn
}

resource "newrelic_cloud_azure_link_account" "production" {
  account_id      = newrelic_account_management.platform.id
  name            = "production"
  application_id  = "application"
  subscription_id = "subscription"
  tenant_id       = "tenant"
  client_secret   = "ROOTFORM_NEWRELIC_AZURE_SECRET_SENTINEL"
}

resource "newrelic_cloud_gcp_link_account" "production" {
  account_id            = newrelic_account_management.platform.id
  name                  = "production"
  project_id            = "rootform-project"
  service_account_email = google_service_account.newrelic.email
}

resource "newrelic_cloud_oci_link_account" "production" {
  account_id        = newrelic_account_management.platform.id
  name              = "production"
  tenant_id         = "ocid1.tenancy.oc1..rootform"
  compartment_ocid  = "ocid1.compartment.oc1..rootform"
  oci_client_id     = "rootform-client"
  oci_client_secret = "ROOTFORM_NEWRELIC_OCI_SECRET_SENTINEL"
  oci_domain_url    = "https://identity.rootform.invalid"
}

data "newrelic_cloud_account" "production" {
  account_id     = newrelic_account_management.platform.id
  cloud_provider = "aws"
  name           = "production"
}

resource "newrelic_cloud_aws_integrations" "production" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_aws_link_account.production.id
}

resource "newrelic_cloud_aws_govcloud_integrations" "government" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_aws_govcloud_link_account.government.id
}

resource "newrelic_cloud_aws_eu_sovereign_integrations" "sovereign" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_aws_eu_sovereign_link_account.sovereign.id
}

resource "newrelic_cloud_azure_integrations" "production" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_azure_link_account.production.id
}

resource "newrelic_cloud_gcp_integrations" "production" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_gcp_link_account.production.id
}

resource "newrelic_cloud_gcp_dm_integrations" "production" {
  account_id        = newrelic_account_management.platform.id
  linked_account_id = newrelic_cloud_gcp_link_account.production.id
}

resource "newrelic_federated_logs_setup" "logs" {
  account_id = newrelic_account_management.platform.id
  name       = "logs"
  storage {
    data_ingest_connection_id = newrelic_aws_connection.ingest.id
    query_connection_id       = newrelic_aws_connection.ingest.id
    data_location_bucket      = "rootform-logs"
    database                  = "rootform_logs"
  }
}

resource "newrelic_federated_logs_partition" "application" {
  account_id = newrelic_account_management.platform.id
  setup_id   = newrelic_federated_logs_setup.logs.id
  name       = "application"
}

resource "newrelic_fleet" "production" {
  name                = "production"
  managed_entity_type = "KUBERNETESCLUSTER"
}

resource "newrelic_fleet_configuration" "otel" {
  name                  = "otel"
  agent_type            = "NRDOT"
  managed_entity_type   = "KUBERNETESCLUSTER"
  configuration_content = "ROOTFORM_NEWRELIC_FLEET_CONFIG_SENTINEL"
}

data "newrelic_fleet_configuration" "otel" {
  name = "otel"
}

resource "newrelic_fleet_deployment" "otel" {
  fleet_id = newrelic_fleet.production.id
  name     = "otel"
}

resource "newrelic_fleet_members" "production" {
  fleet_id = newrelic_fleet.production.id
}

data "newrelic_fleet_members" "production" {
  fleet_id = newrelic_fleet.production.id
}

resource "newrelic_synthetics_private_location" "private" {
  account_id  = newrelic_account_management.platform.id
  name        = "private"
  description = "private execution"
}

data "newrelic_synthetics_private_location" "private" {
  account_id = newrelic_account_management.platform.id
  name       = "private"
}

resource "newrelic_synthetics_broken_links_monitor" "links" {
  account_id        = newrelic_account_management.platform.id
  name              = "links"
  uri               = "https://rootform.invalid"
  locations_private = [newrelic_synthetics_private_location.private.guid]
}

resource "newrelic_synthetics_cert_check_monitor" "certificate" {
  account_id        = newrelic_account_management.platform.id
  name              = "certificate"
  domain            = "rootform.invalid"
  locations_private = [newrelic_synthetics_private_location.private.guid]
}

resource "newrelic_synthetics_monitor" "api" {
  account_id        = newrelic_account_management.platform.id
  name              = "api"
  uri               = "https://rootform.invalid/health"
  locations_private = [newrelic_synthetics_private_location.private.guid]
}

resource "newrelic_synthetics_script_monitor" "browser" {
  account_id = newrelic_account_management.platform.id
  name       = "browser"
  script     = "ROOTFORM_NEWRELIC_SCRIPT_SENTINEL"
  location_private {
    guid = newrelic_synthetics_private_location.private.guid
  }
}

resource "newrelic_synthetics_step_monitor" "checkout" {
  account_id = newrelic_account_management.platform.id
  name       = "checkout"
  location_private {
    guid = newrelic_synthetics_private_location.private.guid
  }
}

resource "newrelic_cardinality_management" "metrics" {
  cardinality_limit = 100000
}

resource "newrelic_data_partition_rule" "logs" {
  account_id            = newrelic_account_management.platform.id
  target_data_partition = "logs"
  nrql                  = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_events_to_metrics_rule" "latency" {
  account_id = newrelic_account_management.platform.id
  name       = "latency"
  nrql       = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_log_parsing_rule" "application" {
  account_id = newrelic_account_management.platform.id
  name       = "application"
  grok       = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_metric_pruning_rule" "metrics" {
  account_id = newrelic_account_management.platform.id
  nrql       = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_nrql_drop_rule" "logs" {
  account_id = newrelic_account_management.platform.id
  nrql       = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_obfuscation_expression" "credentials" {
  account_id = newrelic_account_management.platform.id
  name       = "credentials"
  regex      = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

data "newrelic_obfuscation_expression" "credentials" {
  account_id = newrelic_account_management.platform.id
  name       = "credentials"
}

resource "newrelic_obfuscation_rule" "credentials" {
  account_id = newrelic_account_management.platform.id
  name       = "credentials"
}

resource "newrelic_pipeline_cloud_rule" "logs" {
  account_id = newrelic_account_management.platform.id
  name       = "logs"
  nrql       = "ROOTFORM_NEWRELIC_NRQL_SENTINEL"
}

resource "newrelic_service_level" "availability" {
  guid = "backend-guid"
  name = "availability"
}

resource "newrelic_workload" "checkout" {
  account_id = newrelic_account_management.platform.id
  name       = "checkout"
}

resource "newrelic_workflow_automation" "remediation" {
  name       = "remediation"
  scope_id   = newrelic_account_management.platform.id
  scope_type = "ACCOUNT"
  definition = "ROOTFORM_NEWRELIC_WORKFLOW_DEFINITION_SENTINEL"
}

resource "newrelic_one_dashboard" "must_not_create_topology" {
  name = "ROOTFORM_NEWRELIC_DASHBOARD_SENTINEL"
}
