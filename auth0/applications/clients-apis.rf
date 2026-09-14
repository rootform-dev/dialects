concept "api-resource-server" {
  description = "An API registered as an Auth0 resource server for authorized applications."
}

rule "client" {
  match {
    type = "auth0_client"
  }

  as = concept.identity-application

  relation "defaults-to-organization" {
    to  = concept.customer-organization
    via = source.default_organization[0].organization_id
  }

  relation "uses-api" {
    to  = concept.api-resource-server
    via = source.resource_server_identifier
  }
}

rule "client-cimd" {
  match {
    type = "auth0_client_cimd"
  }

  as = concept.identity-application

  relation "defaults-to-organization" {
    to  = concept.customer-organization
    via = source.default_organization[0].organization_id
  }
}

rule "client-lookup" {
  match {
    kind = "data"
    type = "auth0_client"
  }

  as = concept.identity-application

  relation "defaults-to-organization" {
    to  = concept.customer-organization
    via = source.default_organization[0].organization_id
  }

  relation "uses-api" {
    to  = concept.api-resource-server
    via = source.resource_server_identifier
  }
}

rule "resource-server" {
  match {
    type = "auth0_resource_server"
  }

  as = concept.api-resource-server
}

rule "resource-server-lookup" {
  match {
    kind = "data"
    type = "auth0_resource_server"
  }

  as = concept.api-resource-server
}
