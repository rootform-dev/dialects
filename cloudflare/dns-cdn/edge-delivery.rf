concept "edge-delivery-configuration" {
  description = "Cache, routing, transformation, or delivery configuration applied at the Cloudflare edge."
}

rule "argo-smart-routing" {
  match {
    type = "cloudflare_argo_smart_routing"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "argo-tiered-caching" {
  match {
    type = "cloudflare_argo_tiered_caching"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "tiered-cache" {
  match {
    type = "cloudflare_tiered_cache"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "regional-tiered-cache" {
  match {
    type = "cloudflare_regional_tiered_cache"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "zone-cache-reserve" {
  match {
    type = "cloudflare_zone_cache_reserve"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "zone-cache-variants" {
  match {
    type = "cloudflare_zone_cache_variants"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "managed-transforms" {
  match {
    type = "cloudflare_managed_transforms"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "url-normalization-settings" {
  match {
    type = "cloudflare_url_normalization_settings"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "page-rule" {
  match {
    type = "cloudflare_page_rule"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "google-tag-gateway" {
  match {
    type = "cloudflare_google_tag_gateway"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "origin-cloud-region" {
  match {
    type = "cloudflare_origin_cloud_region"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "snippet" {
  match {
    type = "cloudflare_snippet"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "snippets" {
  match {
    type = "cloudflare_snippets"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "snippet-rules" {
  match {
    type = "cloudflare_snippet_rules"
  }

  as = concept.edge-delivery-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}
