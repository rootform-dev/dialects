concept "vector-search-endpoint" {
  description = "A Mosaic AI Vector Search endpoint providing compute for vector indexes."
}

concept "vector-search-index" {
  description = "A governed vector index served through Mosaic AI Vector Search."
}

concept "ai-search-endpoint" {
  description = "A Mosaic AI Search endpoint providing managed search capacity."
}

concept "ai-search-index" {
  description = "A governed Mosaic AI Search index."
}

concept "ai-gateway-service" {
  description = "A governed Mosaic AI Gateway service for models, model providers, or MCP tools."
}

rule "model-serving" {
  match {
    type = "databricks_model_serving"
  }

  as = concept.ai-inference-endpoint
}

rule "model-serving-provisioned-throughput" {
  match {
    type = "databricks_model_serving_provisioned_throughput"
  }

  as = concept.ai-inference-endpoint
}

rule "vector-search-endpoint" {
  match {
    type = "databricks_vector_search_endpoint"
  }

  as = concept.vector-search-endpoint
}

rule "vector-search-index" {
  match {
    type = "databricks_vector_search_index"
  }

  as = concept.vector-search-index

  relation "served-by" {
    to  = concept.vector-search-endpoint
    via = source.endpoint_name
  }
}

rule "ai-search-endpoint" {
  match {
    type = "databricks_ai_search_endpoint"
  }

  as = concept.ai-search-endpoint
}

rule "ai-search-index" {
  match {
    type = "databricks_ai_search_index"
  }

  as = concept.ai-search-index

  relation "served-by" {
    to  = concept.ai-search-endpoint
    via = source.endpoint
  }
}

rule "ai-gateway-mcp-service" {
  match {
    type = "databricks_ai_gateway_mcp_service"
  }

  as = concept.ai-gateway-service
}

rule "ai-gateway-model-provider-service" {
  match {
    type = "databricks_ai_gateway_model_provider_service"
  }

  as = concept.ai-gateway-service
}

rule "ai-gateway-model-service" {
  match {
    type = "databricks_ai_gateway_model_service"
  }

  as = concept.ai-gateway-service
}
