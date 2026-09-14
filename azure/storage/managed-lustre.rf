# Maintained directly from pinned provider evidence.
rule "managed-lustre-file-system" {
  match {
    type = "azurerm_managed_lustre_file_system"
  }

  as = concept.managed-file-storage

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
