concept "cloudflare-tunnel" {
  description = "A Cloudflare Tunnel logical link from private resources to the Cloudflare network."
}


concept "tunnel-configuration" {
  description = "Ingress, private route, hostname route, or connector configuration supporting a Cloudflare Tunnel."
}

concept "connectivity-service" {
  description = "A service published through Cloudflare Connectivity Directory."
}

concept "warp-connector" {
  description = "A Cloudflare WARP Connector joining a private network to Cloudflare."
}

rule "cloudflare-tunnel" {
  match {
    type = "cloudflare_zero_trust_tunnel_cloudflared"
  }

  as = concept.cloudflare-tunnel
}

rule "cloudflare-tunnel-config" {
  match {
    type = "cloudflare_zero_trust_tunnel_cloudflared_config"
  }

  as = concept.tunnel-configuration

  contribution {
    to  = concept.cloudflare-tunnel
    via = source.tunnel_id
  }
}
rule "cloudflare-tunnel-route" {
  match {
    type = "cloudflare_zero_trust_tunnel_cloudflared_route"
  }

  as = concept.tunnel-configuration

  contribution {
    to  = concept.cloudflare-tunnel
    via = source.tunnel_id
  }

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.network
  }
}


rule "cloudflare-tunnel-hostname-route" {
  match {
    type = "cloudflare_zero_trust_network_hostname_route"
  }

  as = concept.tunnel-configuration

  contribution {
    to  = concept.cloudflare-tunnel
    via = source.tunnel_id
  }
}

rule "connectivity-directory-service" {
  match {
    type = "cloudflare_connectivity_directory_service"
  }

  as = concept.connectivity-service

  relation "uses-tunnel" {
    to  = concept.cloudflare-tunnel
    via = source.host.network.tunnel_id
  }

  relation "uses-tunnel" {
    to  = concept.cloudflare-tunnel
    via = source.host.resolver_network.tunnel_id
  }
}

rule "warp-connector" {
  match {
    type = "cloudflare_zero_trust_tunnel_warp_connector"
  }

  as = concept.warp-connector
}

rule "warp-connector-config" {
  match {
    type = "cloudflare_zero_trust_tunnel_warp_connector_config"
  }

  as = concept.tunnel-configuration

  contribution {
    to  = concept.warp-connector
    via = source.tunnel_id
  }
}
