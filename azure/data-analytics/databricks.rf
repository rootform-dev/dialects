# Maintained directly from pinned provider evidence.
concept "databricks-workspace" {
  description = "An Azure Databricks workspace."
}

rule "databricks-workspace" {
  match {
    type = "azurerm_databricks_workspace"
  }

  as = concept.databricks-workspace

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
