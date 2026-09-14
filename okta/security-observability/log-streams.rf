concept "identity-log-stream" {
  description = "An Okta System Log stream delivering security events to an external destination."
}

rule "log-stream" {
  match {
    type = "okta_log_stream"
  }

  as = concept.identity-log-stream
}

rule "log-stream-lookup" {
  match {
    kind = "data"
    type = "okta_log_stream"
  }

  as = concept.identity-log-stream
}
