
concept "database-migration-connection" {
  description = "A source, destination, or private connection used by Database Migration Service."
}


rule "database-migration-connection-profile" {
  match {
    type = "google_database_migration_service_connection_profile"
  }

  as = concept.database-migration-connection
}

rule "database-migration-private-connection" {
  match {
    type = "google_database_migration_service_private_connection"
  }

  as = concept.database-migration-connection
}
