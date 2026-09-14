concept "ai-gateway" {
  description = "A Cloudflare AI Gateway controlling and observing AI inference traffic."
}

concept "ai-gateway-routing" {
  description = "Dynamic routing configuration contributing to a Cloudflare AI Gateway."
}



rule "ai-gateway" {
  match {
    type = "cloudflare_ai_gateway"
  }

  as = concept.ai-gateway
}

rule "ai-gateway-dynamic-routing" {
  match {
    type = "cloudflare_ai_gateway_dynamic_routing"
  }

  as = concept.ai-gateway-routing

  contribution {
    to  = concept.ai-gateway
    via = source.gateway_id
  }
}
