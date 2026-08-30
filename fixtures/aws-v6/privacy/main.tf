terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.62.0"
    }
  }
}

resource "aws_instance" "private" {
  ami       = "ami-synthetic"
  user_data = "rootform-user-data-secret-sentinel"
}

resource "aws_iam_role" "private" {
  name               = "private"
  assume_role_policy = "rootform-iam-policy-secret-sentinel"
}

resource "aws_kms_key" "private" {
  policy = "rootform-kms-policy-secret-sentinel"
}

resource "aws_secretsmanager_secret" "private" {
  name        = "private"
  description = "rootform-secret-value-sentinel"
}
