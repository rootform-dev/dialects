terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "2.23.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "consul_admin_partition" "first" {
  name = "first"
}

resource "consul_admin_partition" "second" {
  name = "second"
}

resource "consul_namespace" "first" {
  name      = "first"
  partition = consul_admin_partition.first.name
}

resource "consul_namespace" "second" {
  name      = "second"
  partition = consul_admin_partition.second.name
}

resource "consul_node" "first" {
  name    = "first"
  address = "10.10.0.10"
}

resource "consul_node" "second" {
  name    = "second"
  address = "10.10.0.11"
}

resource "aws_vpc" "mismatch" {
  cidr_block = "10.20.0.0/16"
}

resource "consul_service" "literal" {
  name      = "literal"
  node      = "first"
  namespace = "first"
  depends_on = [
    consul_node.first,
    consul_namespace.first,
  ]
}

resource "consul_service" "ambiguous" {
  name      = "ambiguous"
  node      = var.choose_first ? consul_node.first.name : consul_node.second.name
  namespace = var.choose_first ? consul_namespace.first.name : consul_namespace.second.name
}

resource "consul_service" "dangling" {
  name      = "dangling"
  node      = consul_node.missing.name
  namespace = consul_namespace.missing.name
}

resource "consul_service" "mismatch" {
  name      = "mismatch"
  node      = aws_vpc.mismatch.id
  namespace = aws_vpc.mismatch.id
}

resource "consul_acl_auth_method" "first" {
  name        = "first"
  type        = "jwt"
  namespace   = consul_namespace.first.name
  config_json = jsonencode({ JWKSURL = "https://identity.rootform.invalid/jwks" })
}

resource "consul_acl_auth_method" "second" {
  name        = "second"
  type        = "jwt"
  namespace   = consul_namespace.second.name
  config_json = jsonencode({ JWKSURL = "https://identity.rootform.invalid/jwks" })
}

resource "consul_acl_binding_rule" "literal" {
  auth_method = "first"
  bind_type   = "service"
  bind_name   = "literal"
  depends_on  = [consul_acl_auth_method.first]
}

resource "consul_acl_binding_rule" "ambiguous" {
  auth_method = var.choose_first ? consul_acl_auth_method.first.name : consul_acl_auth_method.second.name
  bind_type   = "service"
  bind_name   = "ambiguous"
}

resource "consul_acl_binding_rule" "dangling" {
  auth_method = consul_acl_auth_method.missing.name
  bind_type   = "service"
  bind_name   = "dangling"
}

resource "consul_acl_binding_rule" "mismatch" {
  auth_method = aws_vpc.mismatch.id
  bind_type   = "service"
  bind_name   = "mismatch"
}

resource "consul_certificate_authority" "private" {
  connect_provider = "vault"
  config_json      = jsonencode({ Token = "ROOTFORM_CONSUL_BOUNDARY_CA_SENTINEL" })
}

resource "consul_acl_policy" "private" {
  name  = "private"
  rules = "ROOTFORM_CONSUL_BOUNDARY_POLICY_SENTINEL"
}

resource "consul_acl_token" "private" {
  description = "ROOTFORM_CONSUL_BOUNDARY_TOKEN_SENTINEL"
}

resource "consul_keys" "private" {
  key {
    path  = "rootform/private"
    value = "ROOTFORM_CONSUL_BOUNDARY_KV_SENTINEL"
  }
}

resource "consul_license" "private" {
  license = "ROOTFORM_CONSUL_BOUNDARY_LICENSE_SENTINEL"
}
