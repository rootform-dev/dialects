terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.24.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "8.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}

resource "aws_vpc" "application" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_lb" "application" {
  name = "application"
}

resource "azure_virtual_network" "ignored" {
  name = "wrong-provider-spelling"
}

resource "azurerm_virtual_network" "application" {
  name                = "application"
  address_space       = ["10.20.0.0/16"]
  location            = "westeurope"
  resource_group_name = "application"
}

resource "azurerm_lb" "application" {
  name                = "application"
  location            = "westeurope"
  resource_group_name = "application"
}

resource "google_compute_network" "application" {
  name                    = "application"
  auto_create_subnetworks = false
}

resource "google_compute_forwarding_rule" "application" {
  name                  = "application"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_ha_vpn_gateway" "application" {
  name    = "application"
  network = google_compute_network.application.id
}

resource "kubernetes_namespace_v1" "application" {
  metadata {
    name = "application"
  }
}

resource "kubernetes_service_v1" "application" {
  metadata {
    name      = "application"
    namespace = kubernetes_namespace_v1.application.metadata[0].name
  }
  spec {
    type = "LoadBalancer"
  }
}

resource "cloudflare_zone" "edge" {
  account = { id = "account" }
  name    = "example.com"
}

resource "cloudflare_load_balancer_pool" "aws" {
  account_id = "account"
  name       = "aws"
  origins = [{
    name    = "aws"
    address = aws_lb.application.dns_name
  }]
}

resource "cloudflare_load_balancer_pool" "azure" {
  account_id = "account"
  name       = "azure"
  origins = [{
    name    = "azure"
    address = azurerm_lb.application.id
  }]
}

resource "cloudflare_load_balancer_pool" "google" {
  account_id = "account"
  name       = "google"
  origins = [{
    name    = "google"
    address = google_compute_forwarding_rule.application.ip_address
  }]
}

resource "cloudflare_load_balancer_pool" "kubernetes" {
  account_id = "account"
  name       = "kubernetes"
  origins = [{
    name    = "kubernetes"
    address = "kubernetes.example.internal"
  }]

  depends_on = [kubernetes_service_v1.application]
}

resource "cloudflare_load_balancer_pool" "fallback" {
  account_id = "account"
  name       = "fallback"
  origins = [{
    name    = "fallback"
    address = aws_lb.application.dns_name
  }]
}

resource "cloudflare_load_balancer" "edge" {
  zone_id = cloudflare_zone.edge.id
  name    = "app.example.com"
  default_pools = [
    cloudflare_load_balancer_pool.aws.id,
    cloudflare_load_balancer_pool.azure.id,
    cloudflare_load_balancer_pool.google.id,
    cloudflare_load_balancer_pool.kubernetes.id,
  ]
  fallback_pool = cloudflare_load_balancer_pool.fallback.id
}

resource "cloudflare_dns_record" "application" {
  zone_id = cloudflare_zone.edge.id
  name    = "app.example.com"
  type    = "CNAME"
  content = aws_lb.application.dns_name
  proxied = true
  ttl     = 1
}

resource "cloudflare_r2_bucket" "assets" {
  account_id    = "account"
  name          = "assets"
  location      = "WNAM"
  storage_class = "Standard"
}

resource "cloudflare_d1_database" "application" {
  account_id = "account"
  name       = "application"
}

resource "cloudflare_queue" "events" {
  account_id = "account"
  queue_name = "events"
}

resource "cloudflare_workers_kv_namespace" "sessions" {
  account_id = "account"
  title      = "sessions"
}

resource "cloudflare_workers_script" "api" {
  account_id  = "account"
  script_name = "api"
  bindings = [
    {
      name        = "ASSETS"
      type        = "r2_bucket"
      bucket_name = cloudflare_r2_bucket.assets.name
    },
    {
      name        = "DATABASE"
      type        = "d1"
      database_id = cloudflare_d1_database.application.id
    },
    {
      name       = "EVENTS"
      type       = "queue"
      queue_name = cloudflare_queue.events.queue_name
    },
    {
      name         = "SESSIONS"
      type         = "kv_namespace"
      namespace_id = cloudflare_workers_kv_namespace.sessions.id
    },
  ]
}

resource "cloudflare_worker" "jobs" {
  account_id = "account"
  name       = "jobs"
}

resource "cloudflare_worker_version" "jobs" {
  account_id = "account"
  worker_id  = cloudflare_worker.jobs.id
  bindings = [
    {
      name        = "ASSETS"
      type        = "r2_bucket"
      bucket_name = cloudflare_r2_bucket.assets.name
    },
    {
      name        = "DATABASE"
      type        = "d1"
      database_id = cloudflare_d1_database.application.id
    },
    {
      name       = "EVENTS"
      type       = "queue"
      queue_name = cloudflare_queue.events.queue_name
    },
    {
      name         = "SESSIONS"
      type         = "kv_namespace"
      namespace_id = cloudflare_workers_kv_namespace.sessions.id
    },
  ]
}

resource "cloudflare_workers_deployment" "jobs" {
  account_id  = "account"
  script_name = cloudflare_worker.jobs.name
  strategy    = "percentage"
  versions = [{
    percentage = 100
    version_id = cloudflare_worker_version.jobs.id
  }]
}

resource "cloudflare_queue_consumer" "jobs" {
  account_id  = "account"
  queue_id    = cloudflare_queue.events.id
  script_name = cloudflare_worker.jobs.name
}

resource "cloudflare_r2_bucket_event_notification" "assets" {
  account_id  = "account"
  bucket_name = cloudflare_r2_bucket.assets.name
  queue_id    = cloudflare_queue.events.id
}

resource "cloudflare_workers_custom_domain" "api" {
  account_id = "account"
  hostname   = "worker.example.com"
  service    = cloudflare_workers_script.api.script_name
  zone_id    = cloudflare_zone.edge.id
}

resource "cloudflare_zero_trust_access_application" "worker" {
  account_id = "account"
  name       = "Worker API"
  type       = "self_hosted"
  destinations = [{
    type      = "worker"
    worker_id = cloudflare_worker.jobs.id
  }]
}

resource "cloudflare_zero_trust_access_application" "load_balancer" {
  account_id = "account"
  name       = "Application"
  type       = "self_hosted"
  domain     = aws_lb.application.dns_name
}

resource "cloudflare_pages_project" "docs" {
  account_id        = "account"
  name              = "docs"
  production_branch = "main"
}

resource "cloudflare_pages_domain" "docs" {
  account_id   = "account"
  name         = "docs.example.com"
  project_name = cloudflare_pages_project.docs.name
}

resource "cloudflare_workflow" "orders" {
  account_id = "account"
  name       = "orders"
}

resource "cloudflare_pipeline_stream" "events" {
  account_id = "account"
  name       = "events"
  format     = { type = "json" }
}

resource "cloudflare_pipeline_sink" "warehouse" {
  account_id = "account"
  name       = "warehouse"
  type       = "r2"
}

resource "cloudflare_pipeline" "events" {
  account_id = "account"
  name       = "events"
  sql        = "INSERT INTO warehouse SELECT * FROM events"
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "private" {
  account_id = "account"
  name       = "private"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "private" {
  account_id = "account"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.private.id
  config = {
    ingress = [{ hostname = "private.example.com", service = "http://10.10.0.10" }]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "aws" {
  account_id = "account"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.private.id
  network    = aws_vpc.application.cidr_block
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "azure" {
  account_id = "account"
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.private.id
  network    = azurerm_virtual_network.application.address_space[0]
}

resource "cloudflare_connectivity_directory_service" "database" {
  account_id = "account"
  name       = "database"
  type       = "tcp"
  host = {
    hostname = "database.internal"
    network = {
      tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.private.id
    }
  }
  tcp_port = 5432
}

resource "cloudflare_magic_wan_ipsec_tunnel" "google" {
  account_id          = "account"
  name                = "google"
  cloudflare_endpoint = "198.51.100.10"
  customer_endpoint   = google_compute_ha_vpn_gateway.application.vpn_interfaces[0].ip_address
  interface_address   = "169.254.100.1/31"
}

resource "cloudflare_ruleset" "waf" {
  zone_id = cloudflare_zone.edge.id
  name    = "WAF"
  kind    = "zone"
  phase   = "http_request_firewall_custom"
}

resource "cloudflare_turnstile_widget" "login" {
  account_id = "account"
  domains    = ["app.example.com"]
  mode       = "managed"
  name       = "login"
}

resource "cloudflare_ai_gateway" "models" {
  account_id = "account"
  id         = "models"
}

resource "cloudflare_ai_search_instance" "docs" {
  account_id = "account"
  id         = "docs"
}

resource "cloudflare_logpush_job" "security" {
  account_id       = "account"
  dataset          = "gateway_http"
  destination_conf = "r2://logs"
  name             = "security"
}

resource "cloudflare_stream_live_input" "events" {
  account_id = "account"
}

resource "cloudflare_calls_sfu_app" "meetings" {
  account_id = "account"
  name       = "meetings"
}

resource "cloudflare_spectrum_application" "tcp" {
  zone_id       = cloudflare_zone.edge.id
  protocol      = "tcp/443"
  origin_direct = [aws_lb.application.dns_name]
}

resource "cloudflare_waiting_room" "launch" {
  zone_id              = cloudflare_zone.edge.id
  host                 = "app.example.com"
  name                 = "launch"
  new_users_per_minute = 100
  total_active_users   = 1000
}

resource "cloudflare_account" "platform" {
  name = "platform"
  type = "standard"
}

resource "cloudflare_account_dns_settings_internal_view" "private" {
  account_id = cloudflare_account.platform.id
  name       = "private"
  zones      = [cloudflare_zone.edge.id]
}

resource "cloudflare_dns_zone_transfers_peer" "primary" {
  account_id = cloudflare_account.platform.id
  name       = "primary"
}

resource "cloudflare_dns_zone_transfers_incoming" "secondary" {
  name    = "example.com"
  peers   = [cloudflare_dns_zone_transfers_peer.primary.id]
  zone_id = cloudflare_zone.edge.id
}

resource "cloudflare_calls_turn_app" "relay" {
  account_id = cloudflare_account.platform.id
}

resource "cloudflare_magic_transit_cf1_site" "branch" {
  account_id = cloudflare_account.platform.id
  body       = [{ name = "branch" }]
}

resource "cloudflare_notification_policy_webhooks" "operations" {
  account_id = cloudflare_account.platform.id
  name       = "operations"
  url        = "https://hooks.example.invalid/rootform"
  secret     = "ROOTFORM_CLOUDFLARE_WEBHOOK_SECRET_SENTINEL"
}

resource "cloudflare_notification_policy" "tunnel_health" {
  account_id = cloudflare_account.platform.id
  alert_type = "tunnel_health_event"
  name       = "Tunnel health"
  mechanisms = {
    webhooks = [{ id = cloudflare_notification_policy_webhooks.operations.id }]
  }
}

resource "cloudflare_zero_trust_dex_test" "private_application" {
  account_id = cloudflare_account.platform.id
  data = {
    host   = "https://private.example.com"
    kind   = "http"
    method = "GET"
  }
  enabled  = true
  interval = "30m"
  name     = "private-application"
}

resource "cloudflare_certificate_pack" "edge" {
  certificate_authority = "lets_encrypt"
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  zone_id               = cloudflare_zone.edge.id
}

resource "cloudflare_custom_ssl" "edge" {
  certificate = "ROOTFORM_CLOUDFLARE_CERTIFICATE_SENTINEL"
  private_key = "ROOTFORM_CLOUDFLARE_PRIVATE_KEY_SENTINEL"
  zone_id     = cloudflare_zone.edge.id
}

resource "cloudflare_zero_trust_dlp_custom_profile" "customer_data" {
  account_id = cloudflare_account.platform.id
  name       = "customer-data"
}

resource "cloudflare_zero_trust_device_managed_networks" "office" {
  account_id = cloudflare_account.platform.id
  config     = { tls_sockaddr = "office.example.com:443" }
  name       = "office"
  type       = "tls"
}

resource "cloudflare_google_tag_gateway" "analytics" {
  enabled          = true
  endpoint         = "/metrics"
  hide_original_ip = true
  measurement_id   = "G-ROOTFORM"
  zone_id          = cloudflare_zone.edge.id
}

resource "cloudflare_precursor" "login" {
  default_mode = "min-friction"
  zone_id      = cloudflare_zone.edge.id
}

resource "cloudflare_waiting_room_event" "launch" {
  event_end_time   = "2026-09-01T13:00:00Z"
  event_start_time = "2026-09-01T12:00:00Z"
  name             = "launch"
  waiting_room_id  = cloudflare_waiting_room.launch.id
  zone_id          = cloudflare_zone.edge.id
}

resource "cloudflare_email_security_trusted_domains" "application" {
  account_id = cloudflare_account.platform.id
  pattern    = "example.com"
}

resource "cloudflare_stream_webhook" "events" {
  account_id       = cloudflare_account.platform.id
  notification_url = "https://events.example.invalid/stream"
}

resource "cloudflare_zero_trust_gateway_settings" "platform" {
  account_id = cloudflare_account.platform.id
  settings   = { activity_log = { enabled = true } }
}
