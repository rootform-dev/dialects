terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.62.0"
    }
  }
}

variable "vpc_id" {
  type = string
}

resource "aws_vpc" "known" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "dynamic" {
  vpc_id = var.vpc_id
}

resource "aws_instance" "literal" {
  ami       = "ami-synthetic"
  subnet_id = "subnet-literal"
}

resource "aws_instance" "dependency_only" {
  ami        = "ami-synthetic"
  depends_on = [aws_subnet.dynamic]
}

resource "aws_sns_topic" "events" {
  name = "events"
}

resource "aws_sns_topic_subscription" "literal" {
  topic_arn = "arn:aws:sns:synthetic:999988887777:literal"
  protocol  = "sqs"
  endpoint  = "arn:aws:sqs:synthetic:999988887777:literal"
}

resource "aws_s3_bucket_policy" "helper" {
  bucket = "literal"
  policy = "rootform-policy-sentinel"
}

resource "aws_iam_user_ssh_key" "credential" {
  username   = "synthetic"
  encoding   = "SSH"
  public_key = "ssh-ed25519 rootform-public-key-sentinel"
}

resource "aws_lb_listener_certificate" "listener_configuration" {
  listener_arn   = "literal"
  certificate_arn = "literal"
}

resource "aws_rds_export_task" "operation" {}

resource "aws_sagemaker_training_job" "operation" {}

resource "aws_cloudcontrolapi_resource" "opaque" {
  type_name     = "Synthetic::Unknown::Resource"
  desired_state = "rootform-cloudcontrol-sentinel"
}

action "aws_lambda_invoke" "imperative" {
  config {
    function_name = "literal"
  }
}
