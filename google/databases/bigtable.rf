concept "bigtable-table" {
  description = "A table belonging to a Bigtable instance."
}

rule "bigtable-instance" {
  match {
    type = "google_bigtable_instance"
  }

  as = rf.concept.managed-database
}

rule "bigtable-table" {
  match {
    type = "google_bigtable_table"
  }

  as = concept.bigtable-table

  contribution {
    to  = rf.concept.managed-database
    via = source.instance_name
  }
}
