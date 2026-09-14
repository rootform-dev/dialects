rule "service-level-objective" {
  match {
    type = "datadog_service_level_objective"
  }

  as = concept.service-objective
}

rule "service-level-objective-lookup" {
  match {
    kind = "data"
    type = "datadog_service_level_objective"
  }

  as = concept.service-objective
}
