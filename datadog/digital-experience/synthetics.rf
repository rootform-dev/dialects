rule "synthetics-private-location" {
  match {
    type = "datadog_synthetics_private_location"
  }

  as = concept.synthetic-execution-location
}

rule "synthetics-suite" {
  match {
    type = "datadog_synthetics_suite"
  }

  as = concept.synthetic-check
}

rule "synthetics-test" {
  match {
    type = "datadog_synthetics_test"
  }

  as = concept.synthetic-check

  contribution {
    to  = concept.synthetic-execution-location
    via = source.locations
  }
}

rule "synthetics-test-lookup" {
  match {
    kind = "data"
    type = "datadog_synthetics_test"
  }

  as = concept.synthetic-check
}
