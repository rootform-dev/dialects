terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.114.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "hcp_project" "first" {
  name = "rootform-first"
}

resource "hcp_project" "second" {
  name = "rootform-second"
}

resource "hcp_service_principal" "first" {
  name = "rootform-first"
}

resource "hcp_service_principal" "second" {
  name = "rootform-second"
}

resource "aws_vpc" "first" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_vpc" "second" {
  cidr_block = "10.20.0.0/16"
}

resource "aws_iam_role" "mismatch" {
  name = "rootform-mismatch"
}

resource "hcp_hvn" "literal" {
  hvn_id         = "rootform-literal"
  cloud_provider = "aws"
  region         = "us-west-2"
  project_id     = "literal-project"
  depends_on     = [hcp_project.first]
}

resource "hcp_hvn" "ambiguous" {
  hvn_id         = "rootform-ambiguous"
  cloud_provider = "aws"
  region         = "us-west-2"
  project_id     = var.choose_first ? hcp_project.first.resource_id : hcp_project.second.resource_id
}

resource "hcp_hvn" "dangling" {
  hvn_id         = "rootform-dangling"
  cloud_provider = "aws"
  region         = "us-west-2"
  project_id     = hcp_project.missing.resource_id
}

resource "hcp_hvn" "mismatch" {
  hvn_id         = "rootform-mismatch"
  cloud_provider = "aws"
  region         = "us-west-2"
  project_id     = aws_vpc.first.id
}

resource "hcp_aws_network_peering" "literal" {
  hvn_id          = hcp_hvn.literal.hvn_id
  peering_id      = "rootform-literal"
  peer_vpc_id     = "vpc-literal"
  peer_account_id = "123456789012"
  peer_vpc_region = "us-west-2"
  depends_on      = [aws_vpc.first]
}

resource "hcp_aws_network_peering" "ambiguous" {
  hvn_id          = hcp_hvn.literal.hvn_id
  peering_id      = "rootform-ambiguous"
  peer_vpc_id     = var.choose_first ? aws_vpc.first.id : aws_vpc.second.id
  peer_account_id = "123456789012"
  peer_vpc_region = "us-west-2"
}

resource "hcp_aws_network_peering" "dangling" {
  hvn_id          = hcp_hvn.literal.hvn_id
  peering_id      = "rootform-dangling"
  peer_vpc_id     = aws_vpc.missing.id
  peer_account_id = "123456789012"
  peer_vpc_region = "us-west-2"
}

resource "hcp_aws_network_peering" "mismatch" {
  hvn_id          = hcp_hvn.literal.hvn_id
  peering_id      = "rootform-mismatch"
  peer_vpc_id     = aws_iam_role.mismatch.id
  peer_account_id = "123456789012"
  peer_vpc_region = "us-west-2"
}

resource "hcp_iam_workload_identity_provider" "literal" {
  name              = "rootform-literal"
  service_principal = "principal-literal"
  conditional_access = "true"
  depends_on        = [hcp_service_principal.first]
  aws = {
    account_id = "123456789012"
  }
}

resource "hcp_iam_workload_identity_provider" "ambiguous" {
  name              = "rootform-ambiguous"
  service_principal = var.choose_first ? hcp_service_principal.first.resource_name : hcp_service_principal.second.resource_name
  conditional_access = "true"
  aws = {
    account_id = "123456789012"
  }
}

resource "hcp_iam_workload_identity_provider" "mismatch" {
  name              = "rootform-mismatch"
  service_principal = aws_vpc.first.id
  conditional_access = "true"
  aws = {
    account_id = "123456789012"
  }
}

resource "hcp_boundary_cluster" "private" {
  cluster_id = "rootform-private"
  tier       = "standard"
  username   = "rootform-admin"
  password   = "ROOTFORM_HCP_BOUNDARY_PRIVATE_SENTINEL"
}

resource "hcp_vault_secrets_secret" "private" {
  app_name    = "rootform-private"
  secret_name = "private"
  secret_value = "ROOTFORM_HCP_SECRET_PRIVATE_SENTINEL"
}

resource "hcp_vault_radar_source_github_cloud" "private" {
  github_organization = "rootform-dev"
  token               = "ROOTFORM_HCP_RADAR_PRIVATE_SENTINEL"
}

resource "hcp_log_streaming_destination" "private" {
  name = "rootform-private"
  datadog = {
    endpoint        = "https://api.datadoghq.invalid"
    api_key         = "ROOTFORM_HCP_DATADOG_API_SENTINEL"
    application_key = "ROOTFORM_HCP_DATADOG_APP_SENTINEL"
  }
}

resource "hcp_notifications_webhook" "private" {
  name = "rootform-private"
  config = {
    hmac_key = "ROOTFORM_HCP_WEBHOOK_PRIVATE_SENTINEL"
    url      = "https://events.rootform.invalid/private"
  }
}

resource "hcp_waypoint_tfc_config" "private" {
  tfc_org_name = "rootform"
  token        = "ROOTFORM_HCP_TFC_PRIVATE_SENTINEL"
}

resource "hcp_vault_cluster_admin_token" "private" {
  cluster_id = "rootform-private"
}

resource "hcp_consul_cluster_root_token" "private" {
  cluster_id = "rootform-private"
}

resource "hcp_service_principal_key" "private" {
  service_principal = hcp_service_principal.first.resource_name
}
