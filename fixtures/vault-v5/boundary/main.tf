terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "aws_iam_role" "first" {
  name = "rootform-vault-first"
}

resource "aws_iam_role" "second" {
  name = "rootform-vault-second"
}

resource "aws_s3_bucket" "mismatch" {
  bucket = "rootform-vault-mismatch"
}

resource "vault_namespace" "literal" {
  namespace  = "platform"
  path       = "literal"
  depends_on = [aws_iam_role.first]
}

resource "vault_aws_secret_backend" "literal" {
  path       = "aws-literal"
  role_arn   = "arn:aws:iam::123456789012:role/literal"
  depends_on = [aws_iam_role.first]
}

resource "vault_aws_secret_backend" "ambiguous" {
  path     = "aws-ambiguous"
  role_arn = var.choose_first ? aws_iam_role.first.arn : aws_iam_role.second.arn
}

resource "vault_aws_secret_backend" "dangling" {
  path     = "aws-dangling"
  role_arn = aws_iam_role.missing.arn
}

resource "vault_aws_secret_backend" "mismatch" {
  path     = "aws-mismatch"
  role_arn = aws_s3_bucket.mismatch.arn
}

resource "vault_generic_secret" "payload" {
  path = "kv/private"
  data_json = jsonencode({
    password = "ROOTFORM_VAULT_BOUNDARY_SECRET_SENTINEL"
    token    = "ROOTFORM_VAULT_BOUNDARY_TOKEN_SENTINEL"
  })
}

resource "vault_generic_endpoint" "arbitrary" {
  path      = "sys/private"
  data_json = "ROOTFORM_VAULT_GENERIC_ENDPOINT_SENTINEL"
}

data "vault_generic_secret" "payload" {
  path = vault_generic_secret.payload.path
}

ephemeral "vault_kv_secret_v2" "session" {
  mount = "kv"
  name  = "ROOTFORM_VAULT_EPHEMERAL_SENTINEL"
}
