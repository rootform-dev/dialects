# Maintained directly from pinned provider evidence.
concept "batch-account" {
  description = "An Azure Batch account owning pools, jobs, and applications."
}


concept "batch-pool" {
  description = "A pool providing compute capacity to Azure Batch."
}

rule "batch-account" {
  match {
    type = "azurerm_batch_account"
  }

  as = concept.batch-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "batch-application" {
  match {
    type = "azurerm_batch_application"
  }

  as = concept.batch-pool
}


rule "batch-pool" {
  match {
    type = "azurerm_batch_pool"
  }

  as = concept.batch-pool
}
