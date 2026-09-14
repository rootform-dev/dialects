concept "netapp-storage-pool" {
  description = "A NetApp Volumes storage pool providing capacity to volumes."
}

rule "filestore-instance" {
  match {
    type = "google_filestore_instance"
  }

  as = concept.managed-file-storage
}

rule "netapp-storage-pool" {
  match {
    type = "google_netapp_storage_pool"
  }

  as = concept.netapp-storage-pool
}

rule "netapp-volume" {
  match {
    type = "google_netapp_volume"
  }

  as = concept.managed-file-storage

  context {
    as  = context.ownership
    to  = concept.netapp-storage-pool
    via = source.storage_pool
  }
}

rule "parallelstore-instance" {
  match {
    type = "google_parallelstore_instance"
  }

  as = concept.managed-file-storage

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network
  }
}

rule "managed-lustre-instance" {
  match {
    type = "google_lustre_instance"
  }

  as = concept.managed-file-storage
}
