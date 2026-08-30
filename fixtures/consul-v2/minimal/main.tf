terraform {
  required_providers {
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

resource "consul_service" "api" {
  name      = "api"
  node      = consul_node.api.name
  namespace = consul_namespace.applications.name
  port      = 8080
}

resource "consul_config_entry" "mesh" {
  kind        = "mesh"
  name        = "mesh"
  config_json = jsonencode({ TransparentProxy = {} })
}
