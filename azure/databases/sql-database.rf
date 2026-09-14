# Maintained directly from pinned provider evidence.
concept "sql-server" {
  description = "An Azure SQL logical server owning managed databases."
}

rule "sql-elastic-pool" {
  match {
    type = "azurerm_mssql_elasticpool"
  }

  as = concept.database-component
}

rule "sql-failover-group" {
  match {
    type = "azurerm_mssql_failover_group"
  }

  as = concept.database-component
}

rule "sql-managed-database" {
  match {
    type = "azurerm_mssql_managed_database"
  }

  as = concept.logical-database
}

rule "sql-managed-instance" {
  match {
    type = "azurerm_mssql_managed_instance"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
