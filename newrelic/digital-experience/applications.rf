concept "apm-application" {
  description = "An application boundary observed through New Relic APM."
}

concept "application-configuration" {
  description = "Application settings or key transactions supporting New Relic application observability."
}

rule "application-lookup" {
  match {
    kind = "data"
    type = "newrelic_application"
  }

  as = concept.apm-application
}

rule "application-settings" {
  match {
    type = "newrelic_application_settings"
  }

  as = concept.application-configuration
}

rule "browser-application" {
  match {
    type = "newrelic_browser_application"
  }

  as = concept.browser-observability-application

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.account_id
  }
}

rule "key-transaction" {
  match {
    type = "newrelic_key_transaction"
  }

  as = concept.application-configuration
}

rule "key-transaction-lookup" {
  match {
    kind = "data"
    type = "newrelic_key_transaction"
  }

  as = concept.application-configuration
}
