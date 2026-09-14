concept "event-trigger" {
  description = "A MongoDB Atlas App Services trigger responding to a database, schedule, or authentication event."
}

rule "event-trigger" {
  match {
    type = "mongodbatlas_event_trigger"
  }

  as = concept.event-trigger

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}
