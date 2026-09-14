concept "access-application" {
  description = "An application or infrastructure destination protected by Cloudflare Access."
}



concept "identity-provider" {
  description = "An identity provider integrated with Cloudflare Zero Trust."
}






concept "ai-controls-endpoint" {
  description = "An MCP server or portal governed through Cloudflare AI Controls."
}

concept "gateway-configuration" {
  description = "Logging, inspection, or risk-integration configuration for Cloudflare Gateway."
}

rule "access-application" {
  match {
    type = "cloudflare_zero_trust_access_application"
  }

  as = concept.access-application

  relation "protects" {
    to  = concept.load-balancer
    via = source.domain
  }

  relation "protects" {
    to  = concept.serverless-function
    via = source.destinations[0].worker_id
  }

  relation "protects" {
    to  = concept.serverless-function
    via = source.destinations[1].worker_id
  }

  relation "protects" {
    to  = concept.serverless-function
    via = source.destinations[2].worker_id
  }

  relation "protects" {
    to  = concept.serverless-function
    via = source.destinations[3].worker_id
  }
}



rule "access-identity-provider" {
  match {
    type = "cloudflare_zero_trust_access_identity_provider"
  }

  as = concept.identity-provider
}

rule "access-service-token" {
  match {
    type = "cloudflare_zero_trust_access_service_token"
  }

  as = rf.concept.service-identity
}






rule "access-ai-controls-mcp-server" {
  match {
    type = "cloudflare_zero_trust_access_ai_controls_mcp_server"
  }

  as = concept.ai-controls-endpoint
}

rule "access-ai-controls-mcp-portal" {
  match {
    type = "cloudflare_zero_trust_access_ai_controls_mcp_portal"
  }

  as = concept.ai-controls-endpoint
}

rule "gateway-settings" {
  match {
    type = "cloudflare_zero_trust_gateway_settings"
  }

  as = concept.gateway-configuration
}

rule "gateway-logging" {
  match {
    type = "cloudflare_zero_trust_gateway_logging"
  }

  as = concept.gateway-configuration
}

rule "risk-scoring-integration" {
  match {
    type = "cloudflare_zero_trust_risk_scoring_integration"
  }

  as = concept.gateway-configuration
}
