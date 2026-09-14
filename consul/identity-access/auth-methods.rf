concept "access-control-configuration" {
  description = "A binding or attachment supporting a Consul identity boundary."
}

concept "acl-auth-method" {
  description = "A Consul authentication boundary that verifies an external workload identity."
}

rule "acl-auth-method" {
  match {
    type = "consul_acl_auth_method"
  }

  as = concept.acl-auth-method

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "acl-auth-method-lookup" {
  match {
    kind = "data"
    type = "consul_acl_auth_method"
  }

  as = concept.acl-auth-method

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "acl-binding-rule" {
  match {
    type = "consul_acl_binding_rule"
  }

  as = concept.access-control-configuration

  contribution {
    to  = concept.acl-auth-method
    via = source.auth_method
  }
}
