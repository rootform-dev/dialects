# Maintained directly from pinned provider evidence.
rule "qumulo-file-system" {
  match {
    type = "azurerm_qumulo_file_system"
  }

  as = concept.managed-file-storage

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
