concept "database" {
  description = "A Snowflake database containing schemas and governed data objects."
}

concept "schema" {
  description = "A Snowflake schema containing named data-platform objects."
}

rule "database" {
  match {
    type = "snowflake_database"
  }

  as = concept.database

  relation "uses-external-volume" {
    to  = concept.external-volume
    via = source.external_volume
  }
}

rule "secondary-database" {
  match {
    type = "snowflake_secondary_database"
  }

  as = concept.database

  relation "replicates-database" {
    to  = concept.database
    via = source.as_replica_of
  }

  relation "uses-external-volume" {
    to  = concept.external-volume
    via = source.external_volume
  }
}

rule "shared-database" {
  match {
    type = "snowflake_shared_database"
  }

  as = concept.database

  relation "imports-share" {
    to  = concept.data-share
    via = source.from_share
  }

  relation "uses-external-volume" {
    to  = concept.external-volume
    via = source.external_volume
  }
}

rule "schema" {
  match {
    type = "snowflake_schema"
  }

  as = concept.schema

  context {
    as  = context.ownership
    to  = concept.database
    via = source.database
  }

  relation "uses-external-volume" {
    to  = concept.external-volume
    via = source.external_volume
  }
}

rule "postgres-instance" {
  match {
    type = "snowflake_postgres_instance"
  }

  as = rf.concept.managed-database

  relation "uses-storage-integration" {
    to  = concept.storage-integration
    via = source.storage_integration
  }

  relation "uses-network-policy" {
    to  = concept.network-policy
    via = source.network_policy
  }
}
