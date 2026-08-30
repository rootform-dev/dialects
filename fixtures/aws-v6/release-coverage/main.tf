terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.62.0"
    }
  }
}

resource "aws_bedrock_guardrail" "ai" {
  name = "ai"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "api"
}

resource "aws_instance" "compute" {
  ami = "ami-synthetic"
}

resource "aws_eks_cluster" "containers" {
  name = "containers"
}

resource "aws_glue_catalog_database" "analytics" {
  name = "analytics"
}

resource "aws_dynamodb_table" "database" {
  name = "database"
}

resource "aws_codepipeline" "delivery" {
  name = "delivery"
}

resource "aws_route53_zone" "dns" {
  name = "example.invalid"
}

resource "aws_workspaces_workspace" "desktop" {
  directory_id = "d-synthetic"
}

resource "aws_organizations_organization" "governance" {}

resource "aws_m2_application" "hybrid" {
  name = "hybrid"
}

resource "aws_iam_role" "identity" {
  name = "identity"
}

resource "aws_iot_thing" "device" {
  name = "device"
}

resource "aws_globalaccelerator_accelerator" "edge" {
  name = "edge"
}

resource "aws_connect_instance" "contact_center" {
  identity_management_type = "CONNECT_MANAGED"
}

resource "aws_cloudwatch_event_bus" "events" {
  name = "events"
}

resource "aws_dms_replication_instance" "migration" {
  replication_instance_id = "migration"
}

resource "aws_vpc" "network" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_cloudwatch_log_group" "operations" {
  name = "operations"
}

resource "aws_kms_key" "security" {
  description = "security"
}

resource "aws_lambda_function" "serverless" {
  function_name = "serverless"
}

resource "aws_s3_bucket" "storage" {
  bucket = "rootform-synthetic-storage"
}
