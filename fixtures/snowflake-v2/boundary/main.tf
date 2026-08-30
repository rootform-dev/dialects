terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "2.20.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "first" {
  bucket = "rootform-snowflake-first"
}

resource "aws_s3_bucket" "second" {
  bucket = "rootform-snowflake-second"
}

resource "aws_sns_topic" "first" {
  name = "rootform-snowflake-first"
}

resource "aws_sns_topic" "second" {
  name = "rootform-snowflake-second"
}

resource "snowflake_database" "analytics" {
  name = "ANALYTICS"
}

resource "snowflake_schema" "pipelines" {
  database = snowflake_database.analytics.fully_qualified_name
  name     = "PIPELINES"
}

resource "snowflake_warehouse" "first" {
  name = "FIRST"
}

resource "snowflake_warehouse" "second" {
  name = "SECOND"
}

resource "snowflake_storage_integration_aws" "literal" {
  name                      = "LITERAL"
  storage_aws_role_arn      = "arn:aws:iam::123456789012:role/literal"
  storage_allowed_locations = ["s3://literal"]
  depends_on                = [aws_s3_bucket.first]
}

resource "snowflake_storage_integration_aws" "ambiguous" {
  name                      = "AMBIGUOUS"
  storage_aws_role_arn      = "arn:aws:iam::123456789012:role/literal"
  storage_allowed_locations = [var.choose_first ? aws_s3_bucket.first.id : aws_s3_bucket.second.id]
}

resource "snowflake_notification_integration" "literal" {
  name                  = "LITERAL"
  direction             = "OUTBOUND"
  notification_provider = "AWS_SNS"
  aws_sns_topic_arn     = "arn:aws:sns:us-east-1:123456789012:literal"
  depends_on            = [aws_sns_topic.first]
}

resource "snowflake_notification_integration" "ambiguous" {
  name                  = "AMBIGUOUS"
  direction             = "OUTBOUND"
  notification_provider = "AWS_SNS"
  aws_sns_topic_arn     = var.choose_first ? aws_sns_topic.first.arn : aws_sns_topic.second.arn
}

resource "snowflake_stage_external_s3" "literal" {
  database = snowflake_database.analytics.name
  schema   = snowflake_schema.pipelines.fully_qualified_name
  name     = "LITERAL"
  url      = "s3://literal"
  depends_on = [aws_s3_bucket.first]
}

resource "snowflake_task" "ambiguous" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.fully_qualified_name
  name          = "AMBIGUOUS"
  warehouse     = var.choose_first ? snowflake_warehouse.first.fully_qualified_name : snowflake_warehouse.second.fully_qualified_name
  sql_statement = "select 1"
}

resource "snowflake_secret_with_generic_string" "credential" {
  database      = snowflake_database.analytics.name
  schema        = snowflake_schema.pipelines.name
  name          = "PRIVATE_CREDENTIAL"
  secret_string = "ROOTFORM_SNOWFLAKE_BOUNDARY_SECRET_SENTINEL"
}

resource "snowflake_execute" "operation" {
  execute = "ROOTFORM_SNOWFLAKE_EXECUTE_SENTINEL"
  revert  = "select 1"
}

data "snowflake_system_get_privatelink_config" "lookup" {}
