concept "stream-processing-workspace" {
  description = "An Atlas Stream Processing workspace owning processors and registered source or sink connections."
}

concept "stream-connection" {
  description = "A neutral source or sink connection registered with an Atlas Stream Processing workspace."
}

concept "stream-processor" {
  description = "An Atlas Stream Processing processor continuously executing a declared aggregation pipeline."
}

concept "stream-configuration" {
  description = "A failover or runtime configuration supporting Atlas Stream Processing."
}

rule "stream-workspace" {
  match {
    type = "mongodbatlas_stream_workspace"
  }

  as = concept.stream-processing-workspace

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "stream-instance" {
  match {
    type = "mongodbatlas_stream_instance"
  }

  as = concept.stream-processing-workspace

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "stream-connection" {
  match {
    type = "mongodbatlas_stream_connection"
  }

  as = concept.stream-connection

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  context {
    as  = rf.context.runtime
    to  = concept.stream-processing-workspace
    via = source.workspace_name
  }

  context {
    as  = rf.context.runtime
    to  = concept.stream-processing-workspace
    via = source.instance_name
  }

  relation "connects-to-database" {
    to  = rf.concept.managed-database
    via = source.cluster_name
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.azure[0].service_principal_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp[0].service_account_id
  }

  relation "uses-private-endpoint" {
    to  = concept.private-endpoint
    via = source.networking[0].access[0].connection_id
  }
}

rule "stream-connection-failover" {
  match {
    type = "mongodbatlas_stream_connection_failover"
  }

  as = concept.stream-configuration

  contribution {
    to  = concept.stream-connection
    via = source.connection_name
  }
}

rule "stream-private-endpoint" {
  match {
    type = "mongodbatlas_stream_privatelink_endpoint"
  }

  as = concept.private-endpoint

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "connects-to-network-service" {
    to  = rf.concept.virtual-network
    via = source.service_endpoint_id
  }
}

rule "stream-processor" {
  match {
    type = "mongodbatlas_stream_processor"
  }

  as = concept.stream-processor

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  context {
    as  = rf.context.runtime
    to  = concept.stream-processing-workspace
    via = source.workspace_name
  }

  context {
    as  = rf.context.runtime
    to  = concept.stream-processing-workspace
    via = source.instance_name
  }
}
