concept "federated-database-instance" {
  description = "An Atlas Data Federation instance querying Atlas deployments and external data stores through virtual databases."
}

concept "online-archive" {
  description = "An Atlas Online Archive tiering infrequently accessed data from a database deployment."
}

concept "federation-configuration" {
  description = "A query or storage configuration supporting Atlas Data Federation."
}

rule "federated-database-instance" {
  match {
    type = "mongodbatlas_federated_database_instance"
  }

  as = concept.federated-database-instance

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "reads-from-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_stores[0].bucket
  }

  relation "reads-from-database" {
    to  = rf.concept.managed-database
    via = source.storage_stores[0].cluster_name
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.cloud_provider_config[0].aws[0].role_id
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.cloud_provider_config[0].azure[0].role_id
  }
}

rule "online-archive" {
  match {
    type = "mongodbatlas_online_archive"
  }

  as = concept.online-archive

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "archives-from" {
    to  = rf.concept.managed-database
    via = source.cluster_name
  }
}

rule "federated-query-limit" {
  match {
    type = "mongodbatlas_federated_query_limit"
  }

  as = concept.federation-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}
