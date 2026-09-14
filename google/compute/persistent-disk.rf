rule "persistent-disk" {
  match {
    type = "google_compute_disk"
  }

  as = concept.block-storage-volume
}

rule "regional-persistent-disk" {
  match {
    type = "google_compute_region_disk"
  }

  as = concept.block-storage-volume
}
