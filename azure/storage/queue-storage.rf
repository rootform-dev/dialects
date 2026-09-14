# Maintained directly from pinned provider evidence.
rule "queue-storage-queue" {
  match {
    type = "azurerm_storage_queue"
  }

  as = concept.message-queue

  context {
    as  = context.ownership
    to  = concept.storage-account
    via = source.storage_account_id
  }
}
