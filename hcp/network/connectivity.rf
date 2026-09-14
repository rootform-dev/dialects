concept "network-configuration" {
  description = "A route or supporting setting attached to HCP network connectivity."
}

concept "private-link-service" {
  description = "A provider-side private connectivity service exposing an HCP Vault Dedicated cluster to approved consumers."
}

concept "transit-gateway-attachment" {
  description = "An attachment connecting an HVN to an AWS Transit Gateway."
}

rule "aws-network-peering" {
  match {
    type = "hcp_aws_network_peering"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.peer_vpc_id
  }
}

rule "aws-network-peering-lookup" {
  match {
    kind = "data"
    type = "hcp_aws_network_peering"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.peer_vpc_id
  }
}

rule "aws-transit-gateway-attachment" {
  match {
    type = "hcp_aws_transit_gateway_attachment"
  }

  as = concept.transit-gateway-attachment

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "aws-transit-gateway-attachment-lookup" {
  match {
    kind = "data"
    type = "hcp_aws_transit_gateway_attachment"
  }

  as = concept.transit-gateway-attachment

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "azure-peering-connection" {
  match {
    type = "hcp_azure_peering_connection"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_link
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.peer_vnet_name
  }
}

rule "azure-peering-connection-lookup" {
  match {
    kind = "data"
    type = "hcp_azure_peering_connection"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_link
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.peer_vnet_name
  }
}

rule "hvn-peering-connection" {
  match {
    type = "hcp_hvn_peering_connection"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_1
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.hvn_2
  }
}

rule "hvn-peering-connection-lookup" {
  match {
    kind = "data"
    type = "hcp_hvn_peering_connection"
  }

  as = concept.network-peering

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_1
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "peers-with" {
    to  = rf.concept.virtual-network
    via = source.hvn_2
  }
}

rule "hvn-route" {
  match {
    type = "hcp_hvn_route"
  }

  as = concept.network-configuration

  contribution {
    to  = rf.concept.virtual-network
    via = source.hvn_link
  }
}

rule "hvn-route-lookup" {
  match {
    kind = "data"
    type = "hcp_hvn_route"
  }

  as = concept.network-configuration

  contribution {
    to  = rf.concept.virtual-network
    via = source.hvn_link
  }
}

rule "private-link" {
  match {
    type = "hcp_private_link"
  }

  as = concept.private-link-service

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "exposes-vault-cluster" {
    to  = concept.vault-dedicated-cluster
    via = source.vault_cluster_id
  }
}

rule "private-link-lookup" {
  match {
    kind = "data"
    type = "hcp_private_link"
  }

  as = concept.private-link-service

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "exposes-vault-cluster" {
    to  = concept.vault-dedicated-cluster
    via = source.vault_cluster_id
  }
}
