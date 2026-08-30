terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "4.45.2"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

provider "grafana" {
  auth = "ROOTFORM_GRAFANA_BOUNDARY_PROVIDER_TOKEN_SENTINEL"
}

resource "grafana_cloud_private_data_source_connect_network" "first" {
  name   = "first"
  region = "prod-us-east-0"
}

resource "grafana_cloud_private_data_source_connect_network" "second" {
  name   = "second"
  region = "prod-us-east-0"
}

resource "aws_vpc" "mismatch" {
  cidr_block = "10.30.0.0/16"
}

resource "grafana_data_source" "literal" {
  name                                   = "literal"
  type                                   = "prometheus"
  private_data_source_connect_network_id = "first"
  secure_json_data_encoded               = "ROOTFORM_GRAFANA_BOUNDARY_DATA_SOURCE_SECRET_SENTINEL"
  depends_on                             = [grafana_cloud_private_data_source_connect_network.first]
}

resource "grafana_data_source" "ambiguous" {
  name = "ambiguous"
  type = "prometheus"
  private_data_source_connect_network_id = var.choose_first ? grafana_cloud_private_data_source_connect_network.first.id : grafana_cloud_private_data_source_connect_network.second.id
}

resource "grafana_data_source" "dangling" {
  name                                   = "dangling"
  type                                   = "prometheus"
  private_data_source_connect_network_id = grafana_cloud_private_data_source_connect_network.missing.id
}

resource "grafana_data_source" "mismatch" {
  name                                   = "mismatch"
  type                                   = "prometheus"
  private_data_source_connect_network_id = aws_vpc.mismatch.id
}

resource "grafana_apps_secret_securevalue_v1beta1" "private" {
  metadata {
    uid = "private"
  }
  spec {
    value = "ROOTFORM_GRAFANA_BOUNDARY_SECRET_VALUE_SENTINEL"
  }
}

resource "grafana_dashboard" "private" {
  config_json = "ROOTFORM_GRAFANA_BOUNDARY_DASHBOARD_SENTINEL"
}
