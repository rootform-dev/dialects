
concept "alert" {
  description = "A Snowflake alert evaluating a condition and running an action."
}

rule "alert" {
  match {
    type = "snowflake_alert"
  }

  as = concept.alert

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  context {
    as  = rf.context.runtime
    to  = concept.virtual-warehouse
    via = source.warehouse
  }
}
