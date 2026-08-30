terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "3.96.4"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

provider "newrelic" {
  api_key = "ROOTFORM_NEWRELIC_BOUNDARY_SECRET_SENTINEL"
}

resource "newrelic_cloud_aws_link_account" "first" {
  name = "first"
  arn  = aws_iam_role.first.arn
}

resource "newrelic_cloud_aws_link_account" "second" {
  name = "second"
  arn  = aws_iam_role.second.arn
}

resource "aws_iam_role" "first" {
  name = "first"
}

resource "aws_iam_role" "second" {
  name = "second"
}

resource "aws_vpc" "mismatch" {
  cidr_block = "10.50.0.0/16"
}

resource "newrelic_cloud_aws_integrations" "literal" {
  linked_account_id = "first"
  depends_on        = [newrelic_cloud_aws_link_account.first]
}

resource "newrelic_cloud_aws_integrations" "ambiguous" {
  linked_account_id = var.choose_first ? newrelic_cloud_aws_link_account.first.id : newrelic_cloud_aws_link_account.second.id
}

resource "newrelic_cloud_aws_integrations" "dangling" {
  linked_account_id = newrelic_cloud_aws_link_account.missing.id
}

resource "newrelic_cloud_aws_integrations" "mismatch" {
  linked_account_id = aws_vpc.mismatch.id
}

resource "newrelic_synthetics_secure_credential" "private" {
  key   = "private"
  value = "ROOTFORM_NEWRELIC_BOUNDARY_SECRET_SENTINEL"
}

resource "newrelic_one_dashboard_json" "private" {
  json = "ROOTFORM_NEWRELIC_BOUNDARY_DASHBOARD_SENTINEL"
}
