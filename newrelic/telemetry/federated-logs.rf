concept "aws-connection" {
  description = "An AWS role-backed connection used by New Relic to ingest or query data."
}

concept "federated-logs-partition" {
  description = "A storage, retention, and forwarding partition supporting a Federated Logs setup."
}

concept "federated-logs-setup" {
  description = "A New Relic Federated Logs storage and query boundary backed by external cloud storage."
}

rule "aws-connection" {
  match {
    type = "newrelic_aws_connection"
  }

  as = concept.aws-connection

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

}

rule "federated-logs-partition" {
  match {
    type = "newrelic_federated_logs_partition"
  }

  as = concept.federated-logs-partition

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.federated-logs-setup
    via = source.setup_id
  }
}

rule "federated-logs-setup" {
  match {
    type = "newrelic_federated_logs_setup"
  }

  as = concept.federated-logs-setup

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  relation "ingests-through" {
    to  = concept.aws-connection
    via = source.storage[0].data_ingest_connection_id
  }

  relation "queries-through" {
    to  = concept.aws-connection
    via = source.storage[0].query_connection_id
  }
}
