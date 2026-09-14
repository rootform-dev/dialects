# Maintained directly from pinned provider evidence.
rule "data-lake-filesystem" {
  match {
    type = "azurerm_storage_data_lake_gen2_filesystem"
  }

  as = rf.concept.object-storage-container

  context {
    as  = context.ownership
    to  = concept.storage-account
    via = source.storage_account_id
  }
}

rule "data-lake-path" {
  match {
    type = "azurerm_storage_data_lake_gen2_path"
  }

  as = concept.storage-object-detail
}
