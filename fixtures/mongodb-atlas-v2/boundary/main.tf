terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.16.0"
    }
  }
}

variable "choose_first" {
  type    = bool
  default = true
}

resource "aws_vpc" "first" {
  cidr_block = "10.60.0.0/16"
}

resource "aws_vpc" "second" {
  cidr_block = "10.70.0.0/16"
}

resource "aws_vpc_endpoint" "first" {
  vpc_id       = aws_vpc.first.id
  service_name = "first"
}

resource "aws_vpc_endpoint" "second" {
  vpc_id       = aws_vpc.second.id
  service_name = "second"
}

resource "aws_kms_key" "first" {
  description = "first"
}

resource "aws_kms_key" "second" {
  description = "second"
}

resource "mongodbatlas_organization" "platform" {
  name = "Rootform"
}

resource "mongodbatlas_project" "application" {
  name   = "application"
  org_id = mongodbatlas_organization.platform.id
}

resource "mongodbatlas_advanced_cluster" "primary" {
  project_id = mongodbatlas_project.application.id
  name       = "primary"
}

resource "mongodbatlas_network_container" "atlas" {
  project_id      = mongodbatlas_project.application.id
  atlas_cidr_block = "10.80.0.0/16"
}

resource "mongodbatlas_network_peering" "literal" {
  project_id   = mongodbatlas_project.application.id
  container_id = mongodbatlas_network_container.atlas.id
  vpc_id       = "vpc-literal"
}

resource "mongodbatlas_network_peering" "ambiguous" {
  project_id   = mongodbatlas_project.application.id
  container_id = mongodbatlas_network_container.atlas.id
  vpc_id       = var.choose_first ? aws_vpc.first.id : aws_vpc.second.id
}

resource "mongodbatlas_privatelink_endpoint" "literal" {
  project_id    = mongodbatlas_project.application.id
  provider_name = "AWS"
  region        = "US_EAST_1"
}

resource "mongodbatlas_privatelink_endpoint_service" "literal" {
  project_id          = mongodbatlas_project.application.id
  private_link_id     = mongodbatlas_privatelink_endpoint.literal.id
  endpoint_service_id = "vpce-literal"
}

resource "mongodbatlas_privatelink_endpoint_service" "ambiguous" {
  project_id          = mongodbatlas_project.application.id
  private_link_id     = mongodbatlas_privatelink_endpoint.literal.id
  endpoint_service_id = var.choose_first ? aws_vpc_endpoint.first.id : aws_vpc_endpoint.second.id
  depends_on          = [mongodbatlas_advanced_cluster.primary]
}

resource "mongodbatlas_encryption_at_rest" "literal" {
  project_id = mongodbatlas_project.application.id

  aws_kms_config {
    customer_master_key_id = "literal-key"
    role_id                 = "literal-role"
  }
}

resource "mongodbatlas_encryption_at_rest" "ambiguous" {
  project_id = mongodbatlas_project.application.id

  aws_kms_config {
    customer_master_key_id = var.choose_first ? aws_kms_key.first.id : aws_kms_key.second.id
    role_id                 = "literal-role"
  }
}

resource "mongodbatlas_api_key" "credential" {
  org_id      = mongodbatlas_organization.platform.id
  description = "ROOTFORM_ATLAS_API_PRIVATE_KEY"
}

resource "mongodbatlas_cloud_backup_snapshot" "operational" {
  project_id   = mongodbatlas_project.application.id
  cluster_name = mongodbatlas_advanced_cluster.primary.name
  description  = "ROOTFORM_ATLAS_SNAPSHOT_SENTINEL"
}

resource "mongodbatlas_project_invitation" "administration" {
  project_id = mongodbatlas_project.application.id
  username   = "person@example.com"
}

data "mongodbatlas_advanced_cluster" "lookup" {
  project_id = mongodbatlas_project.application.id
  name       = mongodbatlas_advanced_cluster.primary.name
}
