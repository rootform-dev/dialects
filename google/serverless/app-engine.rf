
concept "app-engine-service-version" {
  description = "A deployed App Engine standard or flexible service version."
}


rule "app-engine-standard-service-version" {
  match {
    type = "google_app_engine_standard_app_version"
  }

  as = concept.app-engine-service-version
}

rule "app-engine-flexible-service-version" {
  match {
    type = "google_app_engine_flexible_app_version"
  }

  as = concept.app-engine-service-version
}
