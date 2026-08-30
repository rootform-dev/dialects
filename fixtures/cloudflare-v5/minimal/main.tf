terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.24.0"
    }
  }
}

resource "cloudflare_zone" "application" {
  account = { id = "account" }
  name    = "example.com"
}

resource "cloudflare_r2_bucket" "assets" {
  account_id  = "account"
  name        = "assets"
  location    = "WNAM"
  storage_class = "Standard"
}

resource "cloudflare_workers_script" "application" {
  account_id  = "account"
  script_name = "application"
  bindings = [{
    name        = "ASSETS"
    type        = "r2_bucket"
    bucket_name = cloudflare_r2_bucket.assets.name
  }]
}
