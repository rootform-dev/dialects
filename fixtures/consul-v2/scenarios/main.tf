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

resource "consul_admin_partition" "platform" {
  name = "platform"
}

resource "consul_namespace" "applications" {
  name      = "applications"
  partition = consul_admin_partition.platform.name
}

resource "consul_node" "api" {
  name    = "api-node"
  address = "10.20.0.10"
}

resource "consul_node" "payments" {
  name    = "payments-node"
  address = "10.20.0.11"
}

resource "consul_service" "api" {
  name      = "api"
  node      = consul_node.api.name
  namespace = consul_namespace.applications.name
  port      = 8080
}

resource "consul_service" "payments" {
  name      = "payments"
  node      = consul_node.payments.name
  namespace = consul_namespace.applications.name
  port      = 8081
}

resource "consul_service" "payments_v2" {
  name      = "payments-v2"
  node      = consul_node.payments.name
  namespace = consul_namespace.applications.name
  port      = 8082
}

resource "consul_acl_auth_method" "workloads" {
  name          = "workloads"
  type          = "jwt"
  namespace     = consul_namespace.applications.name
  config_json   = jsonencode({ JWKSURL = "https://identity.rootform.invalid/jwks" })
  max_token_ttl = "5m"
}

resource "consul_acl_binding_rule" "workloads" {
  auth_method = consul_acl_auth_method.workloads.name
  bind_type   = "service"
  bind_name   = "workload"
  selector    = "serviceaccount.namespace==applications"
}

resource "consul_namespace_policy_attachment" "applications" {
  namespace = consul_namespace.applications.name
  policy    = "applications"
}

resource "consul_namespace_role_attachment" "applications" {
  namespace = consul_namespace.applications.name
  role      = "applications"
}

resource "consul_config_entry" "mesh" {
  kind        = "mesh"
  name        = "mesh"
  config_json = jsonencode({ TransparentProxy = {} })
}

resource "consul_config_entry" "proxy_defaults" {
  kind        = "proxy-defaults"
  name        = "global"
  config_json = jsonencode({ Config = { protocol = "http" } })
}

resource "consul_config_entry" "jwt" {
  kind        = "jwt-provider"
  name        = "workloads"
  config_json = jsonencode({ Issuer = "https://identity.rootform.invalid" })
}

resource "consul_certificate_authority" "mesh" {
  connect_provider = "vault"
  config_json      = jsonencode({ Token = "ROOTFORM_CONSUL_CA_TOKEN_SENTINEL" })
}

resource "consul_peering" "edge" {
  peer_name     = "edge"
  peering_token = "ROOTFORM_CONSUL_PEERING_TOKEN_SENTINEL"
}

resource "consul_config_entry" "sameness" {
  kind        = "sameness-group"
  name        = "payments"
  config_json = jsonencode({ Members = [] })
}

resource "consul_config_entry" "api_gateway" {
  kind        = "api-gateway"
  name        = "public"
  config_json = jsonencode({ Listeners = [] })
}

resource "consul_config_entry" "http_route" {
  kind        = "http-route"
  name        = "api"
  config_json = jsonencode({ Parents = [{ Name = consul_config_entry.api_gateway.name }] })
}

resource "consul_config_entry" "inline_certificate" {
  kind = "inline-certificate"
  name = "public"
  config_json = jsonencode({
    Certificate = "ROOTFORM_CONSUL_CERTIFICATE_SENTINEL"
    PrivateKey  = "ROOTFORM_CONSUL_PRIVATE_KEY_SENTINEL"
  })
}

resource "consul_config_entry" "ingress_legacy" {
  kind        = "ingress-gateway"
  name        = "legacy"
  config_json = jsonencode({ Listeners = [] })
}

resource "consul_config_entry" "terminating" {
  kind        = "terminating-gateway"
  name        = "external"
  config_json = jsonencode({ Services = [] })
}

resource "consul_config_entry_service_defaults" "api" {
  name     = consul_service.api.name
  protocol = "http"
}

resource "consul_config_entry_service_intentions" "api" {
  name = consul_service.api.name

  sources {
    name           = consul_service.payments.name
    action         = "allow"
    peer           = consul_peering.edge.peer_name
    sameness_group = consul_config_entry.sameness.name
  }

  jwt {
    providers {
      name = consul_config_entry.jwt.name
    }
  }
}

resource "consul_config_entry_service_resolver" "payments" {
  name = consul_service.payments.name

  redirect {
    service        = consul_service.payments_v2.name
    peer           = consul_peering.edge.peer_name
    sameness_group = consul_config_entry.sameness.name
  }

  failover {
    subset_name    = "*"
    service        = consul_service.payments.name
    sameness_group = consul_config_entry.sameness.name

    targets {
      service = consul_service.payments_v2.name
      peer    = consul_peering.edge.peer_name
    }
  }
}

resource "consul_config_entry_service_router" "api" {
  name = consul_service.api.name

  routes {
    destination {
      service = consul_service.payments.name
    }
  }
}

resource "consul_config_entry_service_splitter" "payments" {
  name = consul_service.payments.name

  splits {
    weight  = 90
    service = consul_service.payments.name
  }

  splits {
    weight  = 10
    service = consul_service.payments_v2.name
  }
}

resource "consul_config_entry_v2_exported_services" "applications" {
  name                     = "applications"
  services                 = [consul_service.api.name, consul_service.payments.name]
  peer_consumers           = [consul_peering.edge.peer_name]
  sameness_group_consumers = [consul_config_entry.sameness.name]
}

resource "consul_intention" "legacy" {
  source_name      = consul_service.api.name
  destination_name = consul_service.payments.name
  action           = "allow"
}

resource "consul_prepared_query" "api" {
  name    = "api"
  service = consul_service.api.name
}

data "consul_service_health" "api" {
  name = consul_service.api.name
}

resource "consul_network_area" "wan" {
  peer_datacenter = "edge"
  retry_join      = ["10.30.0.10"]
  token           = "ROOTFORM_CONSUL_NETWORK_AREA_TOKEN_SENTINEL"
}

resource "consul_autopilot_config" "platform" {
  cleanup_dead_servers = true
}

resource "consul_agent_service" "legacy" {
  name = "legacy-agent-service"
  port = 9090
}

resource "consul_catalog_entry" "legacy" {
  address = "10.20.0.20"
  node    = "legacy-node"
  service = [{ name = "legacy-catalog-service" }]
}

data "consul_acl_auth_method" "workloads" {
  name      = consul_acl_auth_method.workloads.name
  namespace = consul_namespace.applications.name
}

data "consul_service" "api" {
  name = consul_service.api.name
}

data "consul_catalog_service" "payments" {
  name = consul_service.payments.name
}

data "consul_peering" "edge" {
  peer_name = consul_peering.edge.peer_name
}

data "consul_config_entry" "mesh" {
  kind = "mesh"
  name = consul_config_entry.mesh.name
}

data "consul_config_entry" "api_gateway" {
  kind = "api-gateway"
  name = consul_config_entry.api_gateway.name
}

resource "consul_acl_policy" "private" {
  name  = "private"
  rules = "ROOTFORM_CONSUL_POLICY_SENTINEL"
}

resource "consul_acl_role" "private" {
  name = "private"
}

resource "consul_acl_token" "private" {
  description = "ROOTFORM_CONSUL_TOKEN_SENTINEL"
  policies    = [consul_acl_policy.private.name]
}

resource "consul_keys" "private" {
  key {
    path  = "rootform/private"
    value = "ROOTFORM_CONSUL_KV_SENTINEL"
  }
}

resource "consul_license" "private" {
  license = "ROOTFORM_CONSUL_LICENSE_SENTINEL"
}

resource "consul_peering_token" "private" {
  peer_name = "private"
}

resource "aws_vpc" "opaque" {
  cidr_block = "10.40.0.0/16"
}

resource "consul_config_entry" "opaque" {
  kind = "control-plane-request-limit"
  name = "opaque"
  config_json = jsonencode({
    DependsOnTerraformOnly = aws_vpc.opaque.id
    CredentialSentinel     = "ROOTFORM_CONSUL_CONFIG_JSON_SENTINEL"
  })
  depends_on = [aws_vpc.opaque]
}
