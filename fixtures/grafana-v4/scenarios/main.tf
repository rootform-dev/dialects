terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.45.2"
    }
  }
}

provider "grafana" {
  auth                      = "ROOTFORM_GRAFANA_PROVIDER_TOKEN_SENTINEL"
  cloud_access_policy_token = "ROOTFORM_GRAFANA_PROVIDER_CLOUD_TOKEN_SENTINEL"
}

resource "aws_iam_role" "grafana" {
  name               = "grafana-observability"
  assume_role_policy = "{}"
}

resource "azuread_service_principal" "grafana" {
  client_id = "00000000-0000-0000-0000-000000000001"
}

resource "grafana_cloud_stack" "platform" {
  name        = "platform"
  slug        = "platform"
  region_slug = "prod-us-east-0"
}

data "grafana_cloud_stack" "platform" {
  slug = grafana_cloud_stack.platform.slug
}

resource "grafana_organization" "platform" {
  name = "platform"
}

data "grafana_organization" "platform" {
  name = grafana_organization.platform.name
}

resource "grafana_cloud_private_data_source_connect_network" "private" {
  name             = "private"
  region           = "prod-us-east-0"
  stack_identifier = grafana_cloud_stack.platform.slug
}

resource "grafana_data_source" "metrics" {
  name                                   = "metrics"
  type                                   = "prometheus"
  url                                    = "http://prometheus.internal:9090"
  org_id                                 = grafana_organization.platform.org_id
  private_data_source_connect_network_id = grafana_cloud_private_data_source_connect_network.private.id
  secure_json_data_encoded               = "ROOTFORM_GRAFANA_DATA_SOURCE_SECRET_SENTINEL"
}

data "grafana_data_source" "metrics" {
  name                                   = grafana_data_source.metrics.name
  org_id                                 = grafana_organization.platform.org_id
  private_data_source_connect_network_id = grafana_cloud_private_data_source_connect_network.private.id
}

resource "grafana_cloud_provider_aws_account" "production" {
  name     = "production"
  role_arn = aws_iam_role.grafana.arn
  stack_id = grafana_cloud_stack.platform.id
  regions  = ["us-east-1"]
}

data "grafana_cloud_provider_aws_account" "production" {
  resource_id = grafana_cloud_provider_aws_account.production.resource_id
  role_arn    = aws_iam_role.grafana.arn
  stack_id    = grafana_cloud_stack.platform.id
}

resource "grafana_cloud_provider_aws_cloudwatch_scrape_job" "metrics" {
  name                    = "metrics"
  aws_account_resource_id = grafana_cloud_provider_aws_account.production.resource_id
  stack_id                = grafana_cloud_stack.platform.id
  enabled                 = true
}

data "grafana_cloud_provider_aws_cloudwatch_scrape_job" "metrics" {
  resource_id             = grafana_cloud_provider_aws_cloudwatch_scrape_job.metrics.id
  aws_account_resource_id = grafana_cloud_provider_aws_account.production.resource_id
  stack_id                = grafana_cloud_stack.platform.id
}

resource "grafana_cloud_provider_aws_resource_metadata_scrape_job" "inventory" {
  name                    = "inventory"
  aws_account_resource_id = grafana_cloud_provider_aws_account.production.resource_id
  stack_id                = grafana_cloud_stack.platform.id
  enabled                 = true
}

resource "grafana_cloud_provider_azure_credential" "production" {
  name          = "production"
  client_id     = azuread_service_principal.grafana.client_id
  client_secret = "ROOTFORM_GRAFANA_AZURE_SECRET_SENTINEL"
  tenant_id     = "00000000-0000-0000-0000-000000000002"
  stack_id      = grafana_cloud_stack.platform.id
  enabled       = true
}

data "grafana_cloud_provider_azure_credential" "production" {
  resource_id   = grafana_cloud_provider_azure_credential.production.resource_id
  client_id     = azuread_service_principal.grafana.client_id
  client_secret = "ROOTFORM_GRAFANA_AZURE_LOOKUP_SECRET_SENTINEL"
  tenant_id     = "00000000-0000-0000-0000-000000000002"
  stack_id      = grafana_cloud_stack.platform.id
}

resource "grafana_cloud_integration" "kubernetes" {
  slug = "kubernetes"
}

resource "grafana_cloud_plugin_installation" "synthetics" {
  slug       = "grafana-synthetic-monitoring-app"
  stack_slug = grafana_cloud_stack.platform.slug
}

resource "grafana_connections_metrics_endpoint_scrape_job" "external" {
  name                        = "external"
  stack_id                    = grafana_cloud_stack.platform.id
  url                         = "https://metrics.rootform.invalid"
  authentication_method       = "bearer"
  authentication_bearer_token = "ROOTFORM_GRAFANA_METRICS_TOKEN_SENTINEL"
  enabled                     = true
}

data "grafana_connections_metrics_endpoint_scrape_job" "external" {
  id                          = grafana_connections_metrics_endpoint_scrape_job.external.id
  stack_id                    = grafana_cloud_stack.platform.id
  authentication_bearer_token = "ROOTFORM_GRAFANA_METRICS_LOOKUP_TOKEN_SENTINEL"
}

resource "grafana_fleet_management_collector" "alloy" {
  id             = "alloy-production"
  collector_type = "ALLOY"
  enabled        = true
}

data "grafana_fleet_management_collector" "alloy" {
  id = grafana_fleet_management_collector.alloy.id
}

resource "grafana_fleet_management_pipeline" "telemetry" {
  name        = "telemetry"
  contents    = "ROOTFORM_GRAFANA_PIPELINE_CONTENTS_SENTINEL"
  enabled     = true
  config_type = "alloy"
}

resource "grafana_frontend_o11y_app" "web" {
  name     = "web"
  stack_id = grafana_cloud_stack.platform.id
}

data "grafana_frontend_o11y_app" "web" {
  id       = grafana_frontend_o11y_app.web.id
  stack_id = grafana_cloud_stack.platform.id
}

resource "grafana_synthetic_monitoring_probe" "private" {
  name       = "private"
  latitude   = 33.5731
  longitude  = -7.5898
  region     = "casablanca"
  auth_token = "ROOTFORM_GRAFANA_PROBE_TOKEN_SENTINEL"
}

data "grafana_synthetic_monitoring_probe" "private" {
  name = grafana_synthetic_monitoring_probe.private.name
}

resource "grafana_synthetic_monitoring_check" "api" {
  job       = "api"
  target    = "https://api.rootform.invalid/health"
  probes    = [grafana_synthetic_monitoring_probe.private.id]
  frequency = 60000
  timeout   = 10000
  enabled   = true
}

resource "grafana_synthetic_monitoring_installation" "platform" {
  stack_id          = grafana_cloud_stack.platform.id
  sm_access_token   = "ROOTFORM_GRAFANA_SM_TOKEN_SENTINEL"
  metrics_publisher_key = "ROOTFORM_GRAFANA_SM_PUBLISHER_SENTINEL"
}

resource "grafana_k6_project" "performance" {
  name = "performance"
}

data "grafana_k6_project" "performance" {
  id = grafana_k6_project.performance.id
}

resource "grafana_k6_load_test" "checkout" {
  name       = "checkout"
  project_id = grafana_k6_project.performance.id
  script     = "ROOTFORM_GRAFANA_K6_SCRIPT_SENTINEL"
}

data "grafana_k6_load_test" "checkout" {
  id         = grafana_k6_load_test.checkout.id
  project_id = grafana_k6_project.performance.id
}

resource "grafana_k6_installation" "platform" {
  stack_id                  = grafana_cloud_stack.platform.id
  cloud_access_policy_token = "ROOTFORM_GRAFANA_K6_CLOUD_TOKEN_SENTINEL"
  grafana_sa_token          = "ROOTFORM_GRAFANA_K6_GRAFANA_TOKEN_SENTINEL"
  k6_access_token           = "ROOTFORM_GRAFANA_K6_ACCESS_TOKEN_SENTINEL"
}

resource "grafana_asserts_stack" "knowledge" {
  cloud_access_policy_token = "ROOTFORM_GRAFANA_ASSERTS_CLOUD_TOKEN_SENTINEL"
  grafana_token             = "ROOTFORM_GRAFANA_ASSERTS_GRAFANA_TOKEN_SENTINEL"
}

resource "grafana_asserts_log_config" "logs" {
  name            = "logs"
  data_source_uid = grafana_data_source.metrics.uid
}

resource "grafana_asserts_profile_config" "profiles" {
  name            = "profiles"
  data_source_uid = grafana_data_source.metrics.uid
}

resource "grafana_asserts_trace_config" "traces" {
  name            = "traces"
  data_source_uid = grafana_data_source.metrics.uid
}

resource "grafana_asserts_custom_model_rules" "model" {
  name = "model"
}

resource "grafana_asserts_notification_alerts_config" "notifications" {
  name = "notifications"
}

resource "grafana_asserts_prom_rule_file" "rules" {
  name = "rules"
}

resource "grafana_asserts_suppressed_assertions_config" "suppressed" {
  name = "suppressed"
}

resource "grafana_asserts_thresholds" "thresholds" {}

resource "grafana_oncall_integration" "alerts" {
  name = "alerts"
  type = "grafana_alerting"
}

data "grafana_oncall_integration" "alerts" {
  id = grafana_oncall_integration.alerts.id
}

resource "grafana_oncall_route" "critical" {
  integration_id = grafana_oncall_integration.alerts.id
  routing_regex  = "critical"
  routing_type   = "regex"
}

resource "grafana_apps_provisioning_connection_v0alpha1" "github" {
  metadata {
    uid = "github-rootform"
  }
  spec {
    name = "github-rootform"
  }
}

resource "grafana_apps_provisioning_repository_v0alpha1" "dashboards" {
  metadata {
    uid = "dashboards"
  }
  spec {
    title = "dashboards"
    type  = "github"
    connection {
      name = grafana_apps_provisioning_connection_v0alpha1.github.metadata[0].uid
    }
    github {
      url    = "https://github.com/rootform-dev/observability.git"
      branch = "main"
    }
  }
  secure {
    token = {
      value = "ROOTFORM_GRAFANA_GIT_TOKEN_SENTINEL"
    }
  }
}

resource "grafana_apps_secret_keeper_v1beta1" "aws" {
  metadata {
    uid = "aws-secrets"
  }
  spec {
    aws {
      region = "us-east-1"
      assume_role {
        assume_role_arn = aws_iam_role.grafana.arn
      }
    }
  }
}

resource "grafana_apps_secret_securevalue_v1beta1" "database" {
  metadata {
    uid = "database-password"
  }
  spec {
    value = "ROOTFORM_GRAFANA_SECRET_VALUE_SENTINEL"
  }
}

resource "grafana_apps_secret_keeper_activation_v1beta1" "platform" {
  metadata {
    uid = "secrets"
  }
}

resource "grafana_assistant_mcp_server" "operations" {
  name = "operations"
  custom_headers = {
    Authorization = "ROOTFORM_GRAFANA_MCP_HEADER_SENTINEL"
  }
  configuration {
    url = "https://mcp.rootform.invalid"
  }
}

resource "grafana_agento11y_collection" "production" {
  name = "production"
}

resource "grafana_agento11y_evaluator" "quality" {
  evaluator_id = "quality"
  kind         = "heuristic"
  config       = "{}"
}

resource "grafana_agento11y_evaluation_rule" "quality" {
  rule_id       = "quality"
  evaluator_ids = [grafana_agento11y_evaluator.quality.evaluator_id]
  selector      = "user_visible_turn"
}

resource "grafana_agento11y_hook_rule" "guard" {
  rule_id       = "guard"
  evaluator_ids = [grafana_agento11y_evaluator.quality.evaluator_id]
  phase         = "pre_request"
}

resource "grafana_agento11y_rule_action" "collect" {
  rule_id        = grafana_agento11y_evaluation_rule.quality.rule_id
  collection_ids = [grafana_agento11y_collection.production.id]
}

resource "grafana_machine_learning_job" "latency" {
  name            = "latency"
  datasource_type = "prometheus"
  datasource_uid  = grafana_data_source.metrics.uid
}

resource "grafana_machine_learning_outlier_detector" "latency" {
  name            = "latency"
  datasource_type = "prometheus"
  datasource_uid  = grafana_data_source.metrics.uid
}

resource "grafana_machine_learning_alert" "latency" {
  title  = "latency"
  job_id = grafana_machine_learning_job.latency.id
}

resource "grafana_apps_productactivation_appo11yconfig_v1alpha1" "application" {}
resource "grafana_apps_productactivation_dbo11yconfig_v1alpha1" "database" {}
resource "grafana_apps_productactivation_k8so11yconfig_v1alpha1" "kubernetes" {}

resource "grafana_slo" "api" {
  name        = "API availability"
  description = "API objective"
}

resource "grafana_sso_settings" "oidc" {
  provider_name = "generic_oauth"
}

resource "grafana_scim_config" "platform" {
  enable_group_sync = true
  enable_user_sync  = true
}

resource "grafana_dashboard" "must_not_create_topology" {
  config_json = "ROOTFORM_GRAFANA_DASHBOARD_JSON_SENTINEL"
}
