

rule "edge-container-cluster" {
  match {
    type = "google_edgecontainer_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "edge-container-node-pool" {
  match {
    type = "google_edgecontainer_node_pool"
  }

  as = concept.kubernetes-node-pool
}

rule "bare-metal-gdc-cluster" {
  match {
    type = "google_gkeonprem_bare_metal_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "bare-metal-gdc-admin-cluster" {
  match {
    type = "google_gkeonprem_bare_metal_admin_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "bare-metal-gdc-node-pool" {
  match {
    type = "google_gkeonprem_bare_metal_node_pool"
  }

  as = concept.kubernetes-node-pool
}

rule "vmware-gdc-cluster" {
  match {
    type = "google_gkeonprem_vmware_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "vmware-gdc-admin-cluster" {
  match {
    type = "google_gkeonprem_vmware_admin_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "vmware-gdc-node-pool" {
  match {
    type = "google_gkeonprem_vmware_node_pool"
  }

  as = concept.kubernetes-node-pool
}
