

concept "observability-configuration" {
  description = "A rule or test supporting Cloudflare observability."
}

concept "network-monitor" {
  description = "A Cloudflare Network Monitoring configuration."
}



rule "web-analytics-rule" {
  match {
    type = "cloudflare_web_analytics_rule"
  }

  as = concept.observability-configuration
}

rule "network-monitoring" {
  match {
    type = "cloudflare_magic_network_monitoring_configuration"
  }

  as = concept.network-monitor
}

rule "network-monitoring-rule" {
  match {
    type = "cloudflare_magic_network_monitoring_rule"
  }

  as = concept.observability-configuration
}

rule "notification-policy" {
  match {
    type = "cloudflare_notification_policy"
  }

  as = concept.observability-configuration
}

rule "notification-webhook" {
  match {
    type = "cloudflare_notification_policy_webhooks"
  }

  as = concept.observability-configuration
}

rule "dex-test" {
  match {
    type = "cloudflare_zero_trust_dex_test"
  }

  as = concept.network-monitor
}

rule "dex-rule" {
  match {
    type = "cloudflare_zero_trust_dex_rule"
  }

  as = concept.observability-configuration
}

rule "logpull-retention" {
  match {
    type = "cloudflare_logpull_retention"
  }

  as = concept.observability-configuration
}
