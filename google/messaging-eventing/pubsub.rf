rule "pubsub-topic" {
  match {
    type = "google_pubsub_topic"
  }

  as = concept.message-topic

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "pubsub-subscription" {
  match {
    type = "google_pubsub_subscription"
  }

  as = concept.message-subscription

  relation "subscribes-to" {
    to  = concept.message-topic
    via = source.topic
  }

  relation "delivers-to" {
    to  = concept.cloud-run-service
    via = source.push_config[0].push_endpoint
  }

  relation "delivers-to" {
    to  = concept.message-topic
    via = source.dead_letter_policy[0].dead_letter_topic
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "pubsub-lite-topic" {
  match {
    type = "google_pubsub_lite_topic"
  }

  as = concept.message-topic
}

rule "pubsub-lite-subscription" {
  match {
    type = "google_pubsub_lite_subscription"
  }

  as = concept.message-subscription
}
