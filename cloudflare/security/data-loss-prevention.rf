concept "data-loss-prevention-configuration" {
  description = "Cloudflare One Data Loss Prevention profile, dataset, integration, or service configuration."
}

rule "dlp-custom-profile" {
  match {
    type = "cloudflare_zero_trust_dlp_custom_profile"
  }

  as = concept.data-loss-prevention-configuration
}

rule "dlp-predefined-profile" {
  match {
    type = "cloudflare_zero_trust_dlp_predefined_profile"
  }

  as = concept.data-loss-prevention-configuration
}

rule "dlp-dataset" {
  match {
    type = "cloudflare_zero_trust_dlp_dataset"
  }

  as = concept.data-loss-prevention-configuration
}

rule "dlp-integration-entry" {
  match {
    type = "cloudflare_zero_trust_dlp_integration_entry"
  }

  as = concept.data-loss-prevention-configuration
}

rule "dlp-settings" {
  match {
    type = "cloudflare_zero_trust_dlp_settings"
  }

  as = concept.data-loss-prevention-configuration
}
