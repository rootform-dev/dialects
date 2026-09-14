rule "sns-topic" {
  match {
    type = "aws_sns_topic"
  }

  as = concept.message-topic
}

rule "sns-topic-subscription" {
  match {
    type = "aws_sns_topic_subscription"
  }

  as = concept.message-subscription

  relation "subscribes-to" {
    to  = concept.message-topic
    via = source.topic_arn
  }
}
