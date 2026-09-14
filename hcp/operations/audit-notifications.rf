
concept "notification-webhook" {
  description = "A webhook receiving HCP project resource lifecycle events."
}


rule "notifications-webhook" {
  match {
    type = "hcp_notifications_webhook"
  }

  as = concept.notification-webhook

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}
