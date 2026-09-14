# Maintained directly from pinned provider evidence.
rule "mongo-cluster" {
  match {
    type = "azurerm_mongo_cluster"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
