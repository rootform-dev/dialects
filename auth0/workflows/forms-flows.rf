concept "identity-workflow" {
  description = "An Auth0 Form or Flow orchestrating an identity journey."
}

rule "flow" {
  match {
    type = "auth0_flow"
  }

  as = concept.identity-workflow
}

rule "flow-lookup" {
  match {
    kind = "data"
    type = "auth0_flow"
  }

  as = concept.identity-workflow
}

rule "form" {
  match {
    type = "auth0_form"
  }

  as = concept.identity-workflow
}

rule "form-lookup" {
  match {
    kind = "data"
    type = "auth0_form"
  }

  as = concept.identity-workflow
}
