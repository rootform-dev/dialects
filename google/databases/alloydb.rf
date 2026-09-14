concept "alloydb-instance" {
  description = "A database instance contributing compute capacity to an AlloyDB cluster."
}

rule "alloydb-cluster" {
  match {
    type = "google_alloydb_cluster"
  }

  as = rf.concept.managed-database
}

rule "alloydb-instance" {
  match {
    type = "google_alloydb_instance"
  }

  as = concept.alloydb-instance

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster
  }
}
