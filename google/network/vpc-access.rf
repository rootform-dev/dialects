concept "serverless-vpc-access-connector" {
  description = "A Serverless VPC Access connector bridging serverless workloads to a VPC network."
}

rule "serverless-vpc-access-connector" {
  match {
    type = "google_vpc_access_connector"
  }

  as = concept.serverless-vpc-access-connector

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network
  }

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.subnet[0].name
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}
