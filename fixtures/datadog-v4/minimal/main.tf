terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "4.19.0"
    }
  }
}

resource "datadog_child_organization" "platform" {
  name = "platform"
}

resource "datadog_integration_aws_account" "production" {
  aws_account_id = "123456789012"
  aws_partition  = "aws"
}

resource "datadog_observability_pipeline" "logs" {
  name = "production-logs"
}

resource "datadog_logs_archive" "primary" {
  name  = "primary"
  query = "service:api"
}
