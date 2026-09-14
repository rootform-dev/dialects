concept "spanner-database" {
  description = "A database belonging to a Spanner instance."
}

rule "spanner-instance" {
  match {
    type = "google_spanner_instance"
  }

  as = rf.concept.managed-database
}

rule "spanner-database" {
  match {
    type = "google_spanner_database"
  }

  as = concept.spanner-database

  contribution {
    to  = rf.concept.managed-database
    via = source.instance
  }
}
