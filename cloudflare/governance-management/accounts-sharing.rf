concept "account" {
  description = "A Cloudflare account as a tenancy and ownership boundary."
}



concept "feature-flag-application" {
  description = "A Cloudflare feature-flag application."
}

concept "feature-flag" {
  description = "A feature flag owned by a feature-flag application."
}

concept "account-configuration" {
  description = "Configuration applied to a Cloudflare account boundary."
}

rule "account" {
  match {
    type = "cloudflare_account"
  }

  as = concept.account
}



rule "flagship-app" {
  match {
    type = "cloudflare_flagship_app"
  }

  as = concept.feature-flag-application
}

rule "flagship-flag" {
  match {
    type = "cloudflare_flagship_flag"
  }

  as = concept.feature-flag

  contribution {
    to  = concept.feature-flag-application
    via = source.app_id
  }
}

rule "account-dns-settings" {
  match {
    type = "cloudflare_account_dns_settings"
  }

  as = concept.account-configuration

  contribution {
    to  = concept.account
    via = source.account_id
  }
}
