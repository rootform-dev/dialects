concept "tls-configuration" {
  description = "TLS, certificate, trust-store, or authenticated-origin configuration at the Cloudflare edge."
}

rule "authenticated-origin-pulls" {
  match {
    type = "cloudflare_authenticated_origin_pulls"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "authenticated-origin-pulls-certificate" {
  match {
    type = "cloudflare_authenticated_origin_pulls_certificate"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "authenticated-origin-pulls-hostname-certificate" {
  match {
    type = "cloudflare_authenticated_origin_pulls_hostname_certificate"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "authenticated-origin-pulls-settings" {
  match {
    type = "cloudflare_authenticated_origin_pulls_settings"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "certificate-authority-hostname-associations" {
  match {
    type = "cloudflare_certificate_authorities_hostname_associations"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "certificate-pack" {
  match {
    type = "cloudflare_certificate_pack"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "client-certificate" {
  match {
    type = "cloudflare_client_certificate"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "certificate-transparency-alerting" {
  match {
    type = "cloudflare_ct_alerting"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "custom-csr" {
  match {
    type = "cloudflare_custom_csr"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "custom-origin-trust-store" {
  match {
    type = "cloudflare_custom_origin_trust_store"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "custom-ssl" {
  match {
    type = "cloudflare_custom_ssl"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "hostname-tls-setting" {
  match {
    type = "cloudflare_hostname_tls_setting"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "keyless-certificate" {
  match {
    type = "cloudflare_keyless_certificate"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "mtls-certificate" {
  match {
    type = "cloudflare_mtls_certificate"
  }

  as = concept.tls-configuration
}

rule "origin-ca-certificate" {
  match {
    type = "cloudflare_origin_ca_certificate"
  }

  as = concept.tls-configuration
}

rule "origin-tls-compliance-modes" {
  match {
    type = "cloudflare_origin_tls_compliance_modes"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "total-tls" {
  match {
    type = "cloudflare_total_tls"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "universal-ssl-setting" {
  match {
    type = "cloudflare_universal_ssl_setting"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "zone-auto-origin-tls-kex" {
  match {
    type = "cloudflare_zone_auto_origin_tls_kex"
  }

  as = concept.tls-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}
