concept "application-configuration" {
  description = "Credentials, grants, or associations supporting an Auth0 Application."
}

rule "client-credentials" {
  match {
    type = "auth0_client_credentials"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.client_id
  }
}

rule "client-grant" {
  match {
    type = "auth0_client_grant"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.identity-application
    via = source.client_id
  }
}

rule "resource-server-scope" {
  match {
    type = "auth0_resource_server_scope"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.api-resource-server
    via = source.resource_server_identifier
  }
}

rule "resource-server-scopes" {
  match {
    type = "auth0_resource_server_scopes"
  }

  as = concept.application-configuration

  contribution {
    to  = concept.api-resource-server
    via = source.resource_server_identifier
  }
}
