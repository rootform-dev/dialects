rule "frontend-o11y-app" {
  match {
    type = "grafana_frontend_o11y_app"
  }

  as = concept.browser-observability-application

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }
}

rule "frontend-o11y-app-lookup" {
  match {
    kind = "data"
    type = "grafana_frontend_o11y_app"
  }

  as = concept.browser-observability-application

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }
}
