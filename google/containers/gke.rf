rule "gke-cluster" {
  match {
    type = "google_container_cluster"
  }

  as = rf.concept.kubernetes-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network
  }

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.subnetwork
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "gke-node-pool" {
  match {
    type = "google_container_node_pool"
  }

  as = concept.kubernetes-node-pool

  contribution {
    to  = rf.concept.kubernetes-cluster
    via = source.cluster
  }
}

rule "gke-attached-cluster" {
  match {
    type = "google_container_attached_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "gke-aws-cluster" {
  match {
    type = "google_container_aws_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "gke-aws-node-pool" {
  match {
    type = "google_container_aws_node_pool"
  }

  as = concept.kubernetes-node-pool
}

rule "gke-azure-cluster" {
  match {
    type = "google_container_azure_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "gke-azure-node-pool" {
  match {
    type = "google_container_azure_node_pool"
  }

  as = concept.kubernetes-node-pool
}
