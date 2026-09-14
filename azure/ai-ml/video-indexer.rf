# Maintained directly from pinned provider evidence.
concept "video-indexer-account" {
  description = "An Azure AI Video Indexer account."
}

rule "video-indexer-account" {
  match {
    type = "azurerm_video_indexer_account"
  }

  as = concept.video-indexer-account

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
