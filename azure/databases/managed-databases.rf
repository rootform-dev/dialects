# Maintained directly from pinned provider evidence.
rule "mysql-database" {
  match {
    type = "azurerm_mysql_flexible_database"
  }

  as = concept.logical-database

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "mysql-flexible-server" {
  match {
    type = "azurerm_mysql_flexible_server"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "postgresql-backup" {
  match {
    type = "azurerm_postgresql_flexible_server_backup"
  }

  as = concept.database-component
}

rule "postgresql-database" {
  match {
    type = "azurerm_postgresql_flexible_server_database"
  }

  as = concept.logical-database
}
