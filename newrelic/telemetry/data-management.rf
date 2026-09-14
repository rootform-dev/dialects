concept "telemetry-processing-configuration" {
  description = "A parsing, partitioning, pruning, obfuscation, conversion, or Pipeline Control rule."
}

rule "cardinality-management" {
  match {
    type = "newrelic_cardinality_management"
  }

  as = concept.telemetry-processing-configuration
}

rule "data-partition-rule" {
  match {
    type = "newrelic_data_partition_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "events-to-metrics-rule" {
  match {
    type = "newrelic_events_to_metrics_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "log-parsing-rule" {
  match {
    type = "newrelic_log_parsing_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "metric-pruning-rule" {
  match {
    type = "newrelic_metric_pruning_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "nrql-drop-rule" {
  match {
    type = "newrelic_nrql_drop_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "obfuscation-expression" {
  match {
    type = "newrelic_obfuscation_expression"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "obfuscation-expression-lookup" {
  match {
    kind = "data"
    type = "newrelic_obfuscation_expression"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "obfuscation-rule" {
  match {
    type = "newrelic_obfuscation_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "pipeline-cloud-rule" {
  match {
    type = "newrelic_pipeline_cloud_rule"
  }

  as = concept.telemetry-processing-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}
