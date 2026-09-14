concept "ksqldb-cluster" {
  description = "A managed ksqlDB cluster in Confluent Cloud."
}

rule "ksqldb-cluster" {
  match {
    type = "confluent_ksql_cluster"
  }

  as = concept.ksqldb-cluster

  context {
    as  = context.ownership
    to  = concept.environment
    via = source.environment[0].id
  }

  context {
    as  = rf.context.runtime
    to  = concept.kafka-cluster
    via = source.kafka_cluster[0].id
  }

  relation "uses-principal" {
    to  = rf.concept.service-identity
    via = source.credential_identity[0].id
  }
}
