rule "synthetics-broken-links-monitor" {
  match {
    type = "newrelic_synthetics_broken_links_monitor"
  }

  as = concept.synthetic-check

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.synthetic-execution-location
    via = source.locations_private
  }
}

rule "synthetics-cert-check-monitor" {
  match {
    type = "newrelic_synthetics_cert_check_monitor"
  }

  as = concept.synthetic-check

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.synthetic-execution-location
    via = source.locations_private
  }
}

rule "synthetics-monitor" {
  match {
    type = "newrelic_synthetics_monitor"
  }

  as = concept.synthetic-check

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.synthetic-execution-location
    via = source.locations_private
  }
}

rule "synthetics-private-location" {
  match {
    type = "newrelic_synthetics_private_location"
  }

  as = concept.synthetic-execution-location

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "synthetics-private-location-lookup" {
  match {
    kind = "data"
    type = "newrelic_synthetics_private_location"
  }

  as = concept.synthetic-execution-location

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "synthetics-script-monitor" {
  match {
    type = "newrelic_synthetics_script_monitor"
  }

  as = concept.synthetic-check

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.synthetic-execution-location
    via = source.location_private[0].guid
  }
}

rule "synthetics-step-monitor" {
  match {
    type = "newrelic_synthetics_step_monitor"
  }

  as = concept.synthetic-check

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }

  contribution {
    to  = concept.synthetic-execution-location
    via = source.location_private[0].guid
  }
}
