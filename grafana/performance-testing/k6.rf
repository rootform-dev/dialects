concept "performance-test" {
  description = "A k6 test definition supporting a performance-testing project."
}

concept "performance-testing-project" {
  description = "A Grafana Cloud k6 project grouping performance and load tests."
}

rule "k6-load-test" {
  match {
    type = "grafana_k6_load_test"
  }

  as = concept.performance-test

  contribution {
    to  = concept.performance-testing-project
    via = source.project_id
  }
}

rule "k6-load-test-lookup" {
  match {
    kind = "data"
    type = "grafana_k6_load_test"
  }

  as = concept.performance-test

  contribution {
    to  = concept.performance-testing-project
    via = source.project_id
  }
}

rule "k6-project" {
  match {
    type = "grafana_k6_project"
  }

  as = concept.performance-testing-project
}

rule "k6-project-lookup" {
  match {
    kind = "data"
    type = "grafana_k6_project"
  }

  as = concept.performance-testing-project
}
