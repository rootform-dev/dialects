terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.24.0"
    }
  }
}

variable "choose_first" {
  type = bool
}

variable "bindings" {
  type = any
}

variable "origins" {
  type = any
}

variable "private_network" {
  type = string
}

resource "aws_lb" "first" {
  name = "first"
}

resource "aws_lb" "second" {
  name = "second"
}

resource "cloudflare_zone" "edge" {
  account = { id = "account" }
  name    = "example.com"
}

resource "cloudflare_load_balancer_pool" "literal" {
  account_id = "account"
  name       = "literal"
  origins    = [{ name = "literal", address = "origin.example.net" }]
}

resource "cloudflare_load_balancer_pool" "dynamic" {
  account_id = "account"
  name       = "dynamic"
  origins    = var.origins
}

resource "cloudflare_dns_record" "ambiguous" {
  zone_id = cloudflare_zone.edge.id
  name    = "ambiguous.example.com"
  type    = "CNAME"
  content = var.choose_first ? aws_lb.first.dns_name : aws_lb.second.dns_name
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "literal" {
  zone_id = cloudflare_zone.edge.id
  name    = "literal.example.com"
  type    = "CNAME"
  content = "origin.example.net"
  proxied = true
  ttl     = 1
}

resource "cloudflare_workers_script" "dynamic" {
  account_id  = "account"
  script_name = "dynamic"
  bindings    = var.bindings
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "private" {
  account_id = "account"
  name       = "private"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "literal" {
  account_id = "account"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.private.id
  network    = var.private_network
}

resource "cloudflare_r2_bucket" "assets" {
  account_id    = "account"
  name          = "assets"
  location      = "WNAM"
  storage_class = "Standard"
}

resource "cloudflare_queue" "dependency_only" {
  account_id = "account"
  queue_name = "dependency-only"
  depends_on = [cloudflare_r2_bucket.assets]
}

resource "cloudflare_ai_search_token" "credential" {
  account_id = "account"
  instance_id = "search"
  name       = "credential"
}

resource "cloudflare_secrets_store_secret" "sensitive" {
  account_id = "account"
  store_id   = "store"
  name       = "sensitive"
  value      = "ROOTFORM_CLOUDFLARE_SECRET_SENTINEL"
}

data "cloudflare_zone" "lookup" {
  zone_id = cloudflare_zone.edge.id
}
