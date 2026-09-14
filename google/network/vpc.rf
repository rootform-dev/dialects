rule "vpc-network" {
  match {
    type = "google_compute_network"
  }

  as = rf.concept.virtual-network

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "vpc-subnetwork" {
  match {
    type = "google_compute_subnetwork"
  }

  as = rf.concept.subnet

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}
