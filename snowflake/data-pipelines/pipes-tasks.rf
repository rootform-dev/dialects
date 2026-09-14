concept "notification-integration" {
  description = "A Snowflake notification integration connecting cloud messaging or email delivery."
}

concept "data-pipe" {
  description = "A Snowpipe pipe continuously loading staged data into Snowflake."
}

concept "stream-configuration" {
  description = "A Snowflake stream tracking change data for a schema object."
}

rule "notification-integration" {
  match {
    type = "snowflake_notification_integration"
  }

  as = concept.notification-integration

  relation "connects-message-topic" {
    to  = concept.message-topic
    via = source.aws_sns_topic_arn
  }

  relation "connects-message-topic" {
    to  = concept.message-topic
    via = source.gcp_pubsub_topic_name
  }

  relation "connects-message-queue" {
    to  = concept.message-queue
    via = source.aws_sqs_arn
  }

  relation "connects-message-queue" {
    to  = concept.message-queue
    via = source.azure_storage_queue_primary_uri
  }

  relation "connects-message-subscription" {
    to  = concept.message-subscription
    via = source.gcp_pubsub_subscription_name
  }

}

rule "email-notification-integration" {
  match {
    type = "snowflake_email_notification_integration"
  }

  as = concept.notification-integration
}

rule "pipe" {
  match {
    type = "snowflake_pipe"
  }

  as = concept.data-pipe

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  relation "uses-notification-integration" {
    to  = concept.notification-integration
    via = source.integration
  }

  relation "reports-to-notification-integration" {
    to  = concept.notification-integration
    via = source.error_integration
  }

  relation "receives-storage-events" {
    to  = concept.message-topic
    via = source.aws_sns_topic_arn
  }
}

rule "task" {
  match {
    type = "snowflake_task"
  }

  as = concept.workflow

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

  relation "runs-after-task" {
    to  = concept.workflow
    via = source.after[0]
  }

  relation "runs-after-task" {
    to  = concept.workflow
    via = source.after[1]
  }

  relation "finalizes-task" {
    to  = concept.workflow
    via = source.finalize
  }

  relation "reports-to-notification-integration" {
    to  = concept.notification-integration
    via = source.error_integration
  }
}

rule "stream-on-table" {
  match {
    type = "snowflake_stream_on_table"
  }

  as = concept.stream-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }
}

rule "stream-on-view" {
  match {
    type = "snowflake_stream_on_view"
  }

  as = concept.stream-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }
}

rule "stream-on-external-table" {
  match {
    type = "snowflake_stream_on_external_table"
  }

  as = concept.stream-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }
}

rule "stream-on-directory-table" {
  match {
    type = "snowflake_stream_on_directory_table"
  }

  as = concept.stream-configuration

  contribution {
    to  = concept.schema
    via = source.schema
  }

}
