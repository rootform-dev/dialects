terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.114.0"
    }
  }
}

resource "hcp_project" "platform" {
  name = "rootform-platform"
}

resource "hcp_hvn" "security" {
  hvn_id         = "rootform-security"
  cloud_provider = "aws"
  region         = "us-west-2"
  project_id     = hcp_project.platform.resource_id
}

resource "hcp_vault_cluster" "security" {
  cluster_id = "rootform-security"
  hvn_id     = hcp_hvn.security.hvn_id
  project_id = hcp_project.platform.resource_id
}

resource "hcp_private_link" "vault" {
  private_link_id  = "rootform-vault"
  hvn_id           = hcp_hvn.security.hvn_id
  vault_cluster_id = hcp_vault_cluster.security.cluster_id
  project_id       = hcp_project.platform.resource_id
}
