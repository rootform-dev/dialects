concept "source-repository" {
  description = "A source-code repository hosted or connected through Google Cloud developer services."
}

concept "source-connection" {
  description = "A managed connection from Google Cloud developer services to a source host."
}


rule "cloud-build-v2-connection" {
  match {
    type = "google_cloudbuildv2_connection"
  }

  as = concept.source-connection
}

rule "cloud-build-v2-repository" {
  match {
    type = "google_cloudbuildv2_repository"
  }

  as = concept.source-repository
}

rule "developer-connect-connection" {
  match {
    type = "google_developer_connect_connection"
  }

  as = concept.source-connection
}

rule "developer-connect-repository-link" {
  match {
    type = "google_developer_connect_git_repository_link"
  }

  as = concept.source-repository
}


rule "secure-source-manager-repository" {
  match {
    type = "google_secure_source_manager_repository"
  }

  as = concept.source-repository
}

rule "cloud-source-repository" {
  match {
    type = "google_sourcerepo_repository"
  }

  as = concept.source-repository
}
