concept "cloud-router" {
  description = "A Cloud Router exchanging dynamic routes for a VPC network."
}

rule "cloud-router" {
  match {
    type = "google_compute_router"
  }

  as = concept.cloud-router

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
