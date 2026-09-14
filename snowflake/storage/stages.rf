concept "stage" {
  description = "A named Snowflake stage for loading, unloading, or serving files."
}

rule "stage" {
  match {
    type = "snowflake_stage"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "uses-storage-integration" {
    to  = concept.storage-integration
    via = source.storage_integration
  }

  relation "accesses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.url
  }
}

rule "external-azure-stage" {
  match {
    type = "snowflake_stage_external_azure"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "uses-storage-integration" {
    to  = concept.storage-integration
    via = source.storage_integration
  }

  relation "accesses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.url
  }

  relation "uses-notification-integration" {
    to  = concept.notification-integration
    via = source.directory[0].notification_integration
  }
}

rule "external-gcs-stage" {
  match {
    type = "snowflake_stage_external_gcs"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "uses-storage-integration" {
    to  = concept.storage-integration
    via = source.storage_integration
  }

  relation "accesses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.url
  }

  relation "uses-notification-integration" {
    to  = concept.notification-integration
    via = source.directory[0].notification_integration
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.encryption[0].gcs_sse_kms[0].kms_key_id
  }
}

rule "external-s3-stage" {
  match {
    type = "snowflake_stage_external_s3"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "uses-storage-integration" {
    to  = concept.storage-integration
    via = source.storage_integration
  }

  relation "accesses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.url
  }

  relation "receives-storage-events" {
    to  = concept.message-topic
    via = source.directory[0].aws_sns_topic
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.encryption[0].aws_sse_kms[0].kms_key_id
  }
}

rule "external-s3-compatible-stage" {
  match {
    type = "snowflake_stage_external_s3_compatible"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "accesses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.url
  }
}

rule "internal-stage" {
  match {
    type = "snowflake_stage_internal"
  }

  as = concept.stage

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }
}
