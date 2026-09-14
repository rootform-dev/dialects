# Maintained directly from pinned provider evidence.
rule "oracle-autonomous-database" {
  match {
    type = "azurerm_oracle_autonomous_database"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
