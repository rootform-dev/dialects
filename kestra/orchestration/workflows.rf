concept "namespace" {
  description = "A Kestra namespace that organizes orchestration resources."
}

concept "flow" {
  description = "A declaratively managed Kestra orchestration flow."
}

rule "namespace" {
  match {
    type = "kestra_namespace"
  }

  as = concept.namespace
}

rule "flow" {
  match {
    type = "kestra_flow"
  }

  as = concept.flow

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
