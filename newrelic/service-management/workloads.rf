concept "observability-workload" {
  description = "A New Relic operational view grouping related observed entities for health and incident triage."
}

rule "workload" {
  match {
    type = "newrelic_workload"
  }

  as = concept.observability-workload

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}
