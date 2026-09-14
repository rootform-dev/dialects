concept "cortex-agent" {
  description = "A Cortex Agent orchestrating tools across governed structured and unstructured data."
}

concept "cortex-search-service" {
  description = "A Cortex Search service exposing low-latency retrieval over Snowflake data."
}

concept "mcp-server" {
  description = "A Snowflake-managed Model Context Protocol server exposing governed tools."
}

rule "cortex-agent" {
  match {
    type = "snowflake_cortex_agent"
  }

  as = concept.cortex-agent

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }
}

rule "cortex-search-service" {
  match {
    type = "snowflake_cortex_search_service"
  }

  as = concept.cortex-search-service

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }

  context {
    as  = rf.context.runtime
    to  = concept.virtual-warehouse
    via = source.warehouse
  }
}

rule "mcp-server" {
  match {
    type = "snowflake_mcp_server"
  }

  as = concept.mcp-server

  context {
    as  = context.ownership
    to  = concept.schema
    via = source.schema
  }
}
