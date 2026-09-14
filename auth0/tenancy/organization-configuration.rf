rule "organization-client" {
  match {
    type = "auth0_organization_client"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }

  contribution {
    to  = concept.identity-application
    via = source.client_id
  }
}

rule "organization-client-grant" {
  match {
    type = "auth0_organization_client_grant"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }
}

rule "organization-client-lookup" {
  match {
    kind = "data"
    type = "auth0_organization_client"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }

  contribution {
    to  = concept.identity-application
    via = source.client_id
  }
}

rule "organization-clients" {
  match {
    type = "auth0_organization_clients"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }
}

rule "organization-connection" {
  match {
    type = "auth0_organization_connection"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }

  contribution {
    to  = concept.identity-connection
    via = source.connection_id
  }
}

rule "organization-connections" {
  match {
    type = "auth0_organization_connections"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }
}

rule "organization-discovery-domain" {
  match {
    type = "auth0_organization_discovery_domain"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }
}

rule "organization-discovery-domains" {
  match {
    type = "auth0_organization_discovery_domains"
  }

  as = concept.connection-configuration

  contribution {
    to  = concept.customer-organization
    via = source.organization_id
  }
}
