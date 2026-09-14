rule "service-networking-connection" {
  match {
    type = "google_service_networking_connection"
  }

  as = concept.service-networking-detail

  contribution {
    to  = rf.concept.virtual-network
    via = source.network
  }
}

rule "private-services-access-range" {
  match {
    type  = "google_compute_global_address"
    where = source.purpose == "VPC_PEERING" && source.address_type == "INTERNAL"
  }

  as = concept.allocated-network-range

  contribution {
    to  = rf.concept.virtual-network
    via = source.network
  }
}
