rule "hvn" {
  match {
    type = "hcp_hvn"
  }

  as = rf.concept.virtual-network

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "hvn-lookup" {
  match {
    kind = "data"
    type = "hcp_hvn"
  }

  as = rf.concept.virtual-network

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}
