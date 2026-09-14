rule "project-iam-member" {
  match {
    type = "google_project_iam_member"
  }

  as = concept.service-identity-binding

  contribution {
    to  = rf.concept.service-identity
    via = source.member

    match {
      by       = target.email
      strategy = "exact"
    }
  }
}

rule "project-iam-binding" {
  match {
    type = "google_project_iam_binding"
  }

  as = concept.service-identity-binding

  contribution {
    to  = rf.concept.service-identity
    via = source.members

    match {
      by       = target.email
      strategy = "exact"
    }
  }
}

rule "project-iam-policy" {
  match {
    type = "google_project_iam_policy"
  }

  as = concept.service-identity-binding
}
