concept "compute-instance-group" {
  description = "A managed or unmanaged Compute Engine instance group."
}

rule "compute-instance-from-template" {
  match {
    type = "google_compute_instance_from_template"
  }

  as = concept.compute-instance
}

rule "compute-instance-from-machine-image" {
  match {
    type = "google_compute_instance_from_machine_image"
  }

  as = concept.compute-instance
}

rule "unmanaged-instance-group" {
  match {
    type = "google_compute_instance_group"
  }

  as = concept.compute-instance-group
}

rule "zonal-managed-instance-group" {
  match {
    type = "google_compute_instance_group_manager"
  }

  as = concept.compute-instance-group
}

rule "regional-managed-instance-group" {
  match {
    type = "google_compute_region_instance_group_manager"
  }

  as = concept.compute-instance-group
}
