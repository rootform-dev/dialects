terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.83.0"
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
  service_name = "com.amazonaws.vpce.us-east-1.first"
}

resource "aws_vpc_endpoint" "second" {
  vpc_id       = aws_vpc.second.id
  service_name = "com.amazonaws.vpce.us-east-1.second"
}

resource "confluent_environment" "boundary" {
  display_name = "Boundary"
}

resource "confluent_network" "boundary" {
  display_name = "Boundary"
  cloud        = "AWS"
  region       = "us-east-1"
  cidr         = "10.80.0.0/16"

  environment {
    id = confluent_environment.boundary.id
  }
}

resource "confluent_gateway" "boundary" {
  display_name = "Boundary"

  environment {
    id = confluent_environment.boundary.id
  }
}

resource "confluent_access_point" "literal" {
  display_name = "Literal"

  environment {
    id = confluent_environment.boundary.id
  }

  gateway {
    id = confluent_gateway.boundary.id
  }

  aws_ingress_private_link_endpoint {
    vpc_endpoint_id = "vpce-literal"
  }
}

resource "confluent_access_point" "ambiguous" {
  display_name = "Ambiguous"

  environment {
    id = confluent_environment.boundary.id
  }

  gateway {
    id = confluent_gateway.boundary.id
  }

  aws_ingress_private_link_endpoint {
    vpc_endpoint_id = var.choose_first ? aws_vpc_endpoint.first.id : aws_vpc_endpoint.second.id
  }
}

resource "confluent_peering" "literal" {
  display_name = "Literal"

  environment {
    id = confluent_environment.boundary.id
  }

  network {
    id = confluent_network.boundary.id
  }

  aws {
    account         = "111111111111"
    customer_region = "us-east-1"
    vpc             = "vpc-literal"
  }
}

resource "confluent_peering" "ambiguous" {
  display_name = "Ambiguous"

  environment {
    id = confluent_environment.boundary.id
  }

  network {
    id = confluent_network.boundary.id
  }

  aws {
    account         = "111111111111"
    customer_region = "us-east-1"
    vpc             = var.choose_first ? aws_vpc.first.id : aws_vpc.second.id
  }
}

resource "confluent_kafka_cluster" "boundary" {
  display_name = "Boundary"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-1"

  basic {}

  environment {
    id = confluent_environment.boundary.id
  }
}

resource "confluent_kafka_topic" "boundary" {
  topic_name = "boundary"

  kafka_cluster {
    id = confluent_kafka_cluster.boundary.id
  }
}

resource "confluent_connector" "boundary" {
  environment {
    id = confluent_environment.boundary.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.boundary.id
  }

  config_nonsensitive = {
    "connector.class" = "S3_SINK"
    "topics"          = confluent_kafka_topic.boundary.topic_name
    "s3.bucket.name"  = aws_vpc.first.id
  }

  config_sensitive = {
    "aws.secret.access.key" = "ROOTFORM_CONFLUENT_BOUNDARY_SECRET"
  }

  depends_on = [aws_vpc.second]
}

resource "confluent_flink_statement" "boundary" {
  statement_name       = "boundary"
  statement            = "ROOTFORM_CONFLUENT_BOUNDARY_SQL"
  properties_sensitive = { token = "ROOTFORM_CONFLUENT_BOUNDARY_FLINK_SECRET" }

  compute_pool {
    id = "lfcp-literal"
  }

  environment {
    id = confluent_environment.boundary.id
  }

  principal {
    id = "sa-literal"
  }
}

resource "confluent_certificate_authority" "boundary" {
  display_name      = "Boundary"
  certificate_chain = "ROOTFORM_CONFLUENT_BOUNDARY_CERTIFICATE"
}

resource "confluent_api_key" "credential" {
  display_name = "Credential"
}

resource "confluent_invitation" "administration" {
  email = "admin@example.com"
}

resource "confluent_tf_importer" "imperative" {
  path = "imports.tf"
}

data "confluent_kafka_cluster" "lookup" {
  id = "lkc-literal"

  environment {
    id = confluent_environment.boundary.id
  }
}
