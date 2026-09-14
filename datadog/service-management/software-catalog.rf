concept "catalog-definition" {
  description = "An opaque service or entity definition supporting Datadog Software Catalog."
}

rule "service-definition-yaml" {
  match {
    type = "datadog_service_definition_yaml"
  }

  as = concept.catalog-definition
}

rule "software-catalog" {
  match {
    type = "datadog_software_catalog"
  }

  as = concept.catalog-definition
}

rule "software-catalog-lookup" {
  match {
    kind = "data"
    type = "datadog_software_catalog"
  }

  as = concept.catalog-definition
}
