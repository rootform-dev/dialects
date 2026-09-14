concept "jwt-provider" {
  description = "A JWT validation boundary used by Consul service mesh intentions."
}


concept "service-mesh" {
  description = "A Consul service mesh traffic-control and identity boundary."
}

concept "service-networking-configuration" {
  description = "A mesh-wide or service-specific proxy configuration."
}


rule "config-entry-jwt-provider-json" {
  match {
    type  = "consul_config_entry"
    where = source.kind == "jwt-provider"
  }

  as = concept.jwt-provider
}

rule "config-entry-jwt-provider-json-lookup" {
  match {
    kind  = "data"
    type  = "consul_config_entry"
    where = source.kind == "jwt-provider"
  }

  as = concept.jwt-provider
}

rule "config-entry-mesh-json" {
  match {
    type  = "consul_config_entry"
    where = source.kind == "mesh"
  }

  as = concept.service-mesh
}

rule "config-entry-mesh-json-lookup" {
  match {
    kind  = "data"
    type  = "consul_config_entry"
    where = source.kind == "mesh"
  }

  as = concept.service-mesh
}

rule "config-entry-proxy-defaults-json" {
  match {
    type  = "consul_config_entry"
    where = source.kind == "proxy-defaults"
  }

  as = concept.service-networking-configuration
}

rule "config-entry-proxy-defaults-json-lookup" {
  match {
    kind  = "data"
    type  = "consul_config_entry"
    where = source.kind == "proxy-defaults"
  }

  as = concept.service-networking-configuration
}

rule "config-entry-service-defaults" {
  match {
    type = "consul_config_entry_service_defaults"
  }

  as = concept.service-networking-configuration

  contribution {
    to  = concept.consul-service
    via = source.name
  }
}

rule "config-entry-service-defaults-json" {
  match {
    type  = "consul_config_entry"
    where = source.kind == "service-defaults"
  }

  as = concept.service-networking-configuration
}

rule "config-entry-service-defaults-json-lookup" {
  match {
    kind  = "data"
    type  = "consul_config_entry"
    where = source.kind == "service-defaults"
  }

  as = concept.service-networking-configuration
}
