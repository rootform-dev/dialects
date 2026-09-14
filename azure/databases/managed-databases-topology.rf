rule "postgresql-flexible-server" {
  match {
    type = "azurerm_postgresql_flexible_server"
  }

  as = rf.concept.managed-database

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.delegated_subnet_id
  }

  relation "private-name-resolution" {
    to  = concept.dns-zone
    via = source.private_dns_zone_id
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}

rule "mssql-server" {
  match {
    type = "azurerm_mssql_server"
  }

  as = concept.sql-server

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}

rule "mssql-database" {
  match {
    type = "azurerm_mssql_database"
  }

  as = concept.logical-database

  context {
    as  = context.ownership
    to  = concept.sql-server
    via = source.server_id
  }
}
