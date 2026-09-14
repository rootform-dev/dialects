concept "hook-configuration" {
  description = "Verification or key configuration supporting an Okta hook."
}

concept "identity-event-extension" {
  description = "An Okta event or inline hook integrating an external callback into an identity lifecycle."
}

rule "event-hook" {
  match {
    type = "okta_event_hook"
  }

  as = concept.identity-event-extension
}

rule "event-hook-verification" {
  match {
    type = "okta_event_hook_verification"
  }

  as = concept.hook-configuration

  contribution {
    to  = concept.identity-event-extension
    via = source.event_hook_id
  }
}

rule "hook-key" {
  match {
    type = "okta_hook_key"
  }

  as = concept.hook-configuration
}

rule "hook-key-lookup" {
  match {
    kind = "data"
    type = "okta_hook_key"
  }

  as = concept.hook-configuration
}

rule "inline-hook" {
  match {
    type = "okta_inline_hook"
  }

  as = concept.identity-event-extension
}
