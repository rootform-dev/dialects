# Maintained directly from pinned provider evidence.
concept "table-storage-table" {
  description = "An Azure Table Storage table."
}

rule "table-storage-table" {
  match {
    type = "azurerm_storage_table"
  }

  as = concept.table-storage-table

  context {
    as  = context.ownership
    to  = concept.storage-account
    via = source.storage_account_id
  }
}
