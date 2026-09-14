concept "worker-version" {
  description = "An immutable version and resource bindings of a Cloudflare Worker."
}

concept "worker-deployment" {
  description = "The active version rollout of a Cloudflare Worker."
}

concept "worker-route" {
  description = "A route, custom domain, trigger, or subdomain exposing a Cloudflare Worker."
}

concept "workers-kv-namespace" {
  description = "A Cloudflare Workers KV namespace."
}

concept "workers-kv-entry" {
  description = "A Workers KV entry contributing to its namespace."
}


rule "workers-script" {
  match {
    type = "cloudflare_workers_script"
  }

  as = concept.serverless-function

  relation "uses" {
    to  = rf.concept.object-storage-container
    via = source.bindings[0].bucket_name
  }

  relation "uses" {
    to  = rf.concept.managed-database
    via = source.bindings[1].database_id
  }

  relation "publishes-to" {
    to  = concept.message-queue
    via = source.bindings[2].queue_name
  }

  relation "uses" {
    to  = concept.workers-kv-namespace
    via = source.bindings[3].namespace_id
  }

  relation "uses" {
    to  = rf.concept.object-storage-container
    via = source.bindings[4].bucket_name
  }

  relation "uses" {
    to  = rf.concept.managed-database
    via = source.bindings[5].database_id
  }

  relation "publishes-to" {
    to  = concept.message-queue
    via = source.bindings[6].queue_name
  }

  relation "uses" {
    to  = concept.workers-kv-namespace
    via = source.bindings[7].namespace_id
  }
}

rule "worker" {
  match {
    type = "cloudflare_worker"
  }

  as = concept.serverless-function
}

rule "worker-version" {
  match {
    type = "cloudflare_worker_version"
  }

  as = concept.worker-version

  contribution {
    to  = concept.serverless-function
    via = source.worker_id
  }

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bindings[0].bucket_name
  }

  contribution {
    to  = rf.concept.managed-database
    via = source.bindings[1].database_id
  }

  contribution {
    to  = concept.message-queue
    via = source.bindings[2].queue_name
  }

  contribution {
    to  = concept.workers-kv-namespace
    via = source.bindings[3].namespace_id
  }
}

rule "workers-deployment" {
  match {
    type = "cloudflare_workers_deployment"
  }

  as = concept.worker-deployment

  contribution {
    to  = concept.serverless-function
    via = source.script_name
  }
}

rule "workers-route" {
  match {
    type = "cloudflare_workers_route"
  }

  as = concept.worker-route

  contribution {
    to  = concept.serverless-function
    via = source.script
  }

  context {
    as  = context.ownership
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "workers-custom-domain" {
  match {
    type = "cloudflare_workers_custom_domain"
  }

  as = concept.edge-route

  context {
    as  = context.ownership
    to  = concept.dns-zone
    via = source.zone_id
  }

  relation "routes-to" {
    to  = concept.serverless-function
    via = source.service
  }
}

rule "workers-script-subdomain" {
  match {
    type = "cloudflare_workers_script_subdomain"
  }

  as = concept.worker-route

  contribution {
    to  = concept.serverless-function
    via = source.script_name
  }
}

rule "workers-cron-trigger" {
  match {
    type = "cloudflare_workers_cron_trigger"
  }

  as = concept.worker-route

  contribution {
    to  = concept.serverless-function
    via = source.script_name
  }
}


rule "workers-kv-namespace" {
  match {
    type = "cloudflare_workers_kv_namespace"
  }

  as = concept.workers-kv-namespace
}

rule "workers-kv" {
  match {
    type = "cloudflare_workers_kv"
  }

  as = concept.workers-kv-entry

  contribution {
    to  = concept.workers-kv-namespace
    via = source.namespace_id
  }
}
