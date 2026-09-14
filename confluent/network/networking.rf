concept "network-gateway" {
  description = "A Confluent Cloud gateway for private ingress or egress connectivity."
}

concept "network-link-service" {
  description = "A Confluent Cloud Network Linking service published to accepted networks."
}

concept "network-link-endpoint" {
  description = "A Confluent Cloud Network Linking endpoint consuming a link service."
}

concept "private-link-attachment" {
  description = "A Confluent Cloud Private Link Attachment publishing private service connectivity."
}

concept "transit-gateway-attachment" {
  description = "A Confluent Cloud attachment to an AWS Transit Gateway."
}

concept "dns-forwarder" {
  description = "A Confluent Cloud DNS forwarder associated with a gateway."
}

concept "network-configuration" {
  description = "Private access or DNS configuration supporting a Confluent Cloud network."
}

rule "network" {
  match {
    type = "confluent_network"
  }

  as = rf.concept.virtual-network

  context {
    as  = context.ownership
    to  = concept.environment
    via = source.environment[0].id
  }
}

rule "gateway" {
  match {
    type = "confluent_gateway"
  }

  as = concept.network-gateway

  context {
    as  = context.ownership
    to  = concept.environment
    via = source.environment[0].id
  }
}

rule "access-point" {
  match {
    type = "confluent_access_point"
  }

  as = concept.private-endpoint

  relation "uses-gateway" {
    to  = concept.network-gateway
    via = source.gateway[0].id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.aws_ingress_private_link_endpoint[0].vpc_endpoint_id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.azure_ingress_private_link_endpoint[0].private_endpoint_resource_id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.gcp_ingress_private_service_connect_endpoint[0].private_service_connect_connection_id
  }
}

rule "network-peering" {
  match {
    type = "confluent_peering"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network[0].id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.aws[0].vpc
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.azure[0].vnet
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.gcp[0].vpc_network
  }
}

rule "private-link-access" {
  match {
    type = "confluent_private_link_access"
  }

  as = concept.network-configuration

  contribution {
    to  = rf.concept.virtual-network
    via = source.network[0].id
  }
}

rule "private-link-attachment" {
  match {
    type = "confluent_private_link_attachment"
  }

  as = concept.private-link-attachment

  context {
    as  = context.ownership
    to  = concept.environment
    via = source.environment[0].id
  }
}

rule "private-link-attachment-connection" {
  match {
    type = "confluent_private_link_attachment_connection"
  }

  as = concept.private-endpoint

  relation "connects-to-attachment" {
    to  = concept.private-link-attachment
    via = source.private_link_attachment[0].id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.aws[0].vpc_endpoint_id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.azure[0].private_endpoint_resource_id
  }

  relation "connects-to" {
    to  = concept.private-endpoint
    via = source.gcp[0].private_service_connect_connection_id
  }
}

rule "network-link-service" {
  match {
    type = "confluent_network_link_service"
  }

  as = concept.network-link-service

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network[0].id
  }
}

rule "network-link-endpoint" {
  match {
    type = "confluent_network_link_endpoint"
  }

  as = concept.network-link-endpoint

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network[0].id
  }

  relation "connects-to" {
    to  = concept.network-link-service
    via = source.network_link_service[0].id
  }
}

rule "transit-gateway-attachment" {
  match {
    type = "confluent_transit_gateway_attachment"
  }

  as = concept.transit-gateway-attachment

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network[0].id
  }
}

rule "dns-forwarder" {
  match {
    type = "confluent_dns_forwarder"
  }

  as = concept.dns-forwarder

  relation "uses-gateway" {
    to  = concept.network-gateway
    via = source.gateway[0].id
  }
}

rule "dns-record" {
  match {
    type = "confluent_dns_record"
  }

  as = concept.network-configuration
}
