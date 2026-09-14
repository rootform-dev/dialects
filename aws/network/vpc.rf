rule "vpc" {
  match {
    type = "aws_vpc"
  }

  as = rf.concept.virtual-network
}

rule "subnet" {
  match {
    type = "aws_subnet"
  }

  as = rf.concept.subnet

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "vpc-endpoint" {
  match {
    type = "aws_vpc_endpoint"
  }

  as = concept.private-endpoint

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "ec2-transit-gateway" {
  match {
    type = "aws_ec2_transit_gateway"
  }

  as = concept.transit-gateway
}

rule "ec2-transit-gateway-vpc-attachment" {
  match {
    type = "aws_ec2_transit_gateway_vpc_attachment"
  }

  as = concept.transit-gateway-attachment

  contribution {
    to  = concept.transit-gateway
    via = source.transit_gateway_id
  }

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "route-table" {
  match {
    type = "aws_route_table"
  }

  as = concept.route-table

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "security-group" {
  match {
    type = "aws_security_group"
  }

  as = concept.security-group

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "network-acl" {
  match {
    type = "aws_network_acl"
  }

  as = concept.network-acl

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "internet-gateway" {
  match {
    type = "aws_internet_gateway"
  }

  as = concept.internet-gateway

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}

rule "nat-gateway" {
  match {
    type = "aws_nat_gateway"
  }

  as = concept.managed-nat

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.subnet_id
  }
}

rule "vpn-gateway" {
  match {
    type = "aws_vpn_gateway"
  }

  as = concept.vpn-gateway

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }
}


rule "vpn-connection" {
  match {
    type = "aws_vpn_connection"
  }

  as = concept.vpn-connection

  context {
    as  = rf.context.network
    to  = concept.vpn-gateway
    via = source.vpn_gateway_id
  }

  context {
    as  = rf.context.network
    to  = concept.transit-gateway
    via = source.transit_gateway_id
  }
}
