concept "private-endpoint-service" {
  description = "A MongoDB Atlas regional private endpoint service exposed to a customer cloud network."
}

concept "private-endpoint-registration" {
  description = "A registration joining an Atlas private endpoint service to a customer cloud private endpoint."
}

concept "data-service-private-endpoint" {
  description = "A private endpoint connection for Atlas Data Federation or Online Archive."
}

concept "network-configuration" {
  description = "A network access, DNS, or private-connectivity setting supporting an Atlas project."
}

concept "atlas-network-container" {
  description = "An Atlas address-space container used to configure peering, not a customer virtual network."
}

rule "network-container" {
  match {
    type = "mongodbatlas_network_container"
  }

  as = concept.atlas-network-container

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "network-peering" {
  match {
    type = "mongodbatlas_network_peering"
  }

  as = concept.network-peering

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "connects-atlas-network" {
    to  = concept.atlas-network-container
    via = source.container_id
  }

  relation "connects-cloud-network" {
    to  = rf.concept.virtual-network
    via = source.vpc_id
  }

  relation "connects-cloud-network" {
    to  = rf.concept.virtual-network
    via = source.vnet_name
  }

  relation "connects-cloud-network" {
    to  = rf.concept.virtual-network
    via = source.network_name
  }
}

rule "private-endpoint-service" {
  match {
    type = "mongodbatlas_privatelink_endpoint"
  }

  as = concept.private-endpoint-service

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "private-endpoint-registration" {
  match {
    type = "mongodbatlas_privatelink_endpoint_service"
  }

  as = concept.private-endpoint-registration

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "registers-atlas-service" {
    to  = concept.private-endpoint-service
    via = source.private_link_id
  }

  relation "registers-cloud-endpoint" {
    to  = concept.private-endpoint
    via = source.endpoint_service_id
  }
}

rule "data-service-private-endpoint" {
  match {
    type = "mongodbatlas_privatelink_endpoint_service_data_federation_online_archive"
  }

  as = concept.data-service-private-endpoint

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-cloud-endpoint" {
    to  = concept.private-endpoint
    via = source.endpoint_id
  }
}

rule "private-endpoint-regional-mode" {
  match {
    type = "mongodbatlas_private_endpoint_regional_mode"
  }

  as = concept.network-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}

rule "project-ip-access-list" {
  match {
    type = "mongodbatlas_project_ip_access_list"
  }

  as = concept.network-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}

rule "custom-dns-configuration-aws" {
  match {
    type = "mongodbatlas_custom_dns_configuration_cluster_aws"
  }

  as = concept.network-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}
