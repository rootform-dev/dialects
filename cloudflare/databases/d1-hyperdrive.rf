concept "hyperdrive-configuration" {
  description = "A Cloudflare Hyperdrive database accelerator and connection pool."
}

rule "d1-database" {
  match {
    type = "cloudflare_d1_database"
  }

  as = rf.concept.managed-database
}

rule "hyperdrive-config" {
  match {
    type = "cloudflare_hyperdrive_config"
  }

  as = concept.hyperdrive-configuration

  relation "connects-to" {
    to  = rf.concept.managed-database
    via = source.origin.host
  }

  relation "connects-through" {
    to  = concept.connectivity-service
    via = source.origin.service_id
  }
}
