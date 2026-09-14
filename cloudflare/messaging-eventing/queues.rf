concept "queue-consumer-binding" {
  description = "A consumer binding connecting a Cloudflare Queue to a Worker."
}

rule "queue" {
  match {
    type = "cloudflare_queue"
  }

  as = concept.message-queue
}

rule "queue-consumer" {
  match {
    type = "cloudflare_queue_consumer"
  }

  as = concept.queue-consumer-binding

  contribution {
    to  = concept.message-queue
    via = source.queue_id
  }

  contribution {
    to  = concept.serverless-function
    via = source.script_name
  }
}
