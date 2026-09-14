rule "account-lookup" {
  match {
    kind = "data"
    type = "newrelic_account"
  }

  as = concept.observability-tenant
}

rule "account-management" {
  match {
    type = "newrelic_account_management"
  }

  as = concept.observability-tenant
}
