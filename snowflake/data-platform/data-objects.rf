concept "data-object-configuration" {
  description = "A Snowflake table, stream, view, or governed data-object definition supporting a schema."
}

concept "dynamic-table" {
  description = "A Snowflake dynamic table refreshed as a declarative data pipeline workload."
}

rule "dynamic-table" {
  match {
    type = "snowflake_dynamic_table"
  }

  as = concept.dynamic-table

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

rule "external-table" {
  match {
    type = "snowflake_external_table"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "hybrid-table" {
  match {
    type = "snowflake_hybrid_table"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }
}

rule "iceberg-table" {
  match {
    type = "snowflake_iceberg_table"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "iceberg-table-from-aws-glue" {
  match {
    type = "snowflake_iceberg_table_from_aws_glue"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "iceberg-table-from-delta-files" {
  match {
    type = "snowflake_iceberg_table_from_delta_files"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "iceberg-table-from-files" {
  match {
    type = "snowflake_iceberg_table_from_files"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "iceberg-table-from-rest" {
  match {
    type = "snowflake_iceberg_table_from_rest"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}

rule "semantic-view" {
  match {
    type = "snowflake_semantic_view"
  }

  as = concept.data-object-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }
}
