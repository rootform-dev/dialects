
concept "vertex-ai-vector-index" {
  description = "A Vertex AI vector index."
}


concept "vertex-ai-feature-store" {
  description = "A Vertex AI feature store or online feature store."
}





rule "vertex-ai-endpoint" {
  match {
    type = "google_vertex_ai_endpoint"
  }

  as = concept.ai-inference-endpoint
}

rule "vertex-ai-model-garden-endpoint" {
  match {
    type = "google_vertex_ai_endpoint_with_model_garden_deployment"
  }

  as = concept.ai-inference-endpoint
}

rule "vertex-ai-vector-index" {
  match {
    type = "google_vertex_ai_index"
  }

  as = concept.vertex-ai-vector-index
}


rule "vertex-ai-feature-store" {
  match {
    type = "google_vertex_ai_featurestore"
  }

  as = concept.vertex-ai-feature-store
}

rule "vertex-ai-feature-online-store" {
  match {
    type = "google_vertex_ai_feature_online_store"
  }

  as = concept.vertex-ai-feature-store
}
