rule "memorystore-redis-instance" {
  match {
    type = "google_redis_instance"
  }

  as = concept.managed-cache

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.authorized_network
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "memorystore-redis-cluster" {
  match {
    type = "google_redis_cluster"
  }

  as = concept.managed-cache

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "memorystore-memcached-instance" {
  match {
    type = "google_memcache_instance"
  }

  as = concept.managed-cache

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.authorized_network
  }

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}

rule "memorystore-instance" {
  match {
    type = "google_memorystore_instance"
  }

  as = concept.managed-cache

  context {
    as  = context.ownership
    to  = concept.google-cloud-project
    via = source.project
  }
}
