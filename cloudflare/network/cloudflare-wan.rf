concept "magic-transit-site" {
  description = "A Cloudflare Magic Transit or Cloudflare WAN network site."
}



concept "network-route-configuration" {
  description = "A LAN, WAN, ACL, route, or prefix configuration supporting Cloudflare WAN."
}



rule "magic-transit-site" {
  match {
    type = "cloudflare_magic_transit_site"
  }

  as = concept.magic-transit-site
}

rule "magic-transit-cf1-site" {
  match {
    type = "cloudflare_magic_transit_cf1_site"
  }

  as = concept.magic-transit-site
}


rule "magic-transit-site-lan" {
  match {
    type = "cloudflare_magic_transit_site_lan"
  }

  as = concept.network-route-configuration

  context {
    as  = rf.context.network
    to  = concept.magic-transit-site
    via = source.site_id
  }
}

rule "magic-transit-site-wan" {
  match {
    type = "cloudflare_magic_transit_site_wan"
  }

  as = concept.network-route-configuration

  context {
    as  = rf.context.network
    to  = concept.magic-transit-site
    via = source.site_id
  }
}

rule "magic-transit-site-acl" {
  match {
    type = "cloudflare_magic_transit_site_acl"
  }

  as = concept.network-route-configuration

  context {
    as  = rf.context.network
    to  = concept.magic-transit-site
    via = source.site_id
  }
}


rule "magic-wan-ipsec-tunnel" {
  match {
    type = "cloudflare_magic_wan_ipsec_tunnel"
  }

  as = concept.vpn-connection

  relation "connects-to" {
    to  = concept.vpn-gateway
    via = source.customer_endpoint
  }
}

rule "magic-wan-static-route" {
  match {
    type = "cloudflare_magic_wan_static_route"
  }

  as = concept.network-route-configuration
}



rule "cloud-connector-rules" {
  match {
    type = "cloudflare_cloud_connector_rules"
  }

  as = concept.network-route-configuration

  contribution {
    to  = concept.dns-zone
    via = source.zone_id
  }
}
