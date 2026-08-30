terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "4.19.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "datadog_datastore" "first" {
  name                = "first"
  primary_column_name = "id"
}

resource "datadog_datastore" "second" {
  name                = "second"
  primary_column_name = "id"
}

resource "aws_vpc" "mismatch" {
  cidr_block = "10.20.0.0/16"
}

resource "datadog_datastore_item" "literal" {
  datastore_id = "first"
  item_key      = "literal"
  value         = "ROOTFORM_DATADOG_LITERAL_VALUE_SENTINEL"
  depends_on    = [datadog_datastore.first]
}

resource "datadog_datastore_item" "ambiguous" {
  datastore_id = var.choose_first ? datadog_datastore.first.id : datadog_datastore.second.id
  item_key      = "ambiguous"
  value         = "ROOTFORM_DATADOG_AMBIGUOUS_VALUE_SENTINEL"
}

resource "datadog_datastore_item" "dangling" {
  datastore_id = datadog_datastore.missing.id
  item_key      = "dangling"
  value         = "ROOTFORM_DATADOG_DANGLING_VALUE_SENTINEL"
}

resource "datadog_datastore_item" "mismatch" {
  datastore_id = aws_vpc.mismatch.id
  item_key      = "mismatch"
  value         = "ROOTFORM_DATADOG_MISMATCH_VALUE_SENTINEL"
}

provider "datadog" {
  api_key = "ROOTFORM_DATADOG_PROVIDER_API_KEY_SENTINEL"
  app_key = "ROOTFORM_DATADOG_PROVIDER_APP_KEY_SENTINEL"
}

resource "datadog_app_builder_app" "private" {
  name     = "private"
  app_json = "ROOTFORM_DATADOG_BOUNDARY_APP_JSON_SENTINEL"
}

resource "datadog_workflow_automation" "private" {
  name           = "private"
  description    = "private"
  published      = false
  tags           = []
  spec_json      = "ROOTFORM_DATADOG_BOUNDARY_WORKFLOW_SENTINEL"
  webhook_secret = "ROOTFORM_DATADOG_BOUNDARY_WEBHOOK_SECRET_SENTINEL"
}

resource "datadog_integration_azure" "private" {
  tenant_name   = "tenant"
  client_id     = "client"
  client_secret = "ROOTFORM_DATADOG_BOUNDARY_AZURE_SECRET_SENTINEL"
}

resource "datadog_api_key" "private" {
  name = "ROOTFORM_DATADOG_BOUNDARY_API_KEY_SENTINEL"
}

resource "datadog_application_key" "private" {
  name = "ROOTFORM_DATADOG_BOUNDARY_APPLICATION_KEY_SENTINEL"
}

resource "datadog_monitor" "private" {
  name    = "private"
  type    = "metric alert"
  query   = "ROOTFORM_DATADOG_BOUNDARY_MONITOR_QUERY_SENTINEL"
  message = "ROOTFORM_DATADOG_BOUNDARY_MONITOR_MESSAGE_SENTINEL"
}
