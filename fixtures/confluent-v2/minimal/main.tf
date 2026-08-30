terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.83.0"
    }
  }
}

resource "confluent_environment" "production" {
  display_name = "Production"
}

resource "confluent_network" "private" {
  display_name = "Private"
  cloud        = "AWS"
  region       = "us-east-1"
  cidr         = "10.10.0.0/16"

  environment {
    id = confluent_environment.production.id
  }
}

resource "confluent_kafka_cluster" "events" {
  display_name = "Events"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = "us-east-1"

  dedicated {
    cku = 2
  }

  environment {
    id = confluent_environment.production.id
  }

  network {
    id = confluent_network.private.id
  }
}

resource "confluent_kafka_topic" "orders" {
  topic_name       = "orders"
  partitions_count = 12

  kafka_cluster {
    id = confluent_kafka_cluster.events.id
  }
}

resource "confluent_connector" "warehouse" {
  environment {
    id = confluent_environment.production.id
  }

  kafka_cluster {
    id = confluent_kafka_cluster.events.id
  }

  config_nonsensitive = {
    "connector.class" = "SnowflakeSink"
    "topics"          = confluent_kafka_topic.orders.topic_name
  }

  config_sensitive = {
    "snowflake.private.key" = "ROOTFORM_CONFLUENT_MINIMAL_SECRET"
  }
}

data "confluent_schema_registry_cluster" "production" {
  environment {
    id = confluent_environment.production.id
  }
}
