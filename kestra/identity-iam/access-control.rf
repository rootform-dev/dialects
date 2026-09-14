concept "access-role" {
  description = "A Kestra role defining an access permission set."
}

concept "access-binding" {
  description = "A Kestra role binding for an external principal."
}

rule "group" {
  match {
    type = "kestra_group"
  }

  as = concept.identity-group

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace

    match {
      by       = target.namespace_id
      strategy = "dot-ancestor"
    }
  }
}

rule "role" {
  match {
    type = "kestra_role"
  }

  as = concept.access-role

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace

    match {
      by       = target.namespace_id
      strategy = "dot-ancestor"
    }
  }
}

rule "existing-role" {
  match {
    kind = "data"
    type = "kestra_role"
  }

  as = concept.access-role
}

rule "binding" {
  match {
    type = "kestra_binding"
  }

  as = concept.access-binding

  contribution {
    to  = concept.access-role
    via = source.role_id

    match {
      by       = target.role_id
      strategy = "exact"
    }
  }
}
