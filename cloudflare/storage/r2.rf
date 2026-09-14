concept "r2-data-catalog" {
  description = "A Cloudflare R2 Data Catalog for tabular data."
}

concept "r2-configuration" {
  description = "Lifecycle, access, event, migration, or domain configuration contributing to an R2 bucket."
}

rule "r2-bucket" {
  match {
    type = "cloudflare_r2_bucket"
  }

  as = rf.concept.object-storage-container
}

rule "r2-bucket-cors" {
  match {
    type = "cloudflare_r2_bucket_cors"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}
rule "r2-bucket-lifecycle" {
  match {
    type = "cloudflare_r2_bucket_lifecycle"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}

rule "r2-bucket-lock" {
  match {
    type = "cloudflare_r2_bucket_lock"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}

rule "r2-bucket-sippy" {
  match {
    type = "cloudflare_r2_bucket_sippy"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}

rule "r2-bucket-event-notification" {
  match {
    type = "cloudflare_r2_bucket_event_notification"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }

  contribution {
    to  = concept.message-queue
    via = source.queue_id
  }
}

rule "r2-custom-domain" {
  match {
    type = "cloudflare_r2_custom_domain"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }

  context {
    as  = context.ownership
    to  = concept.dns-zone
    via = source.zone_id
  }
}

rule "r2-managed-domain" {
  match {
    type = "cloudflare_r2_managed_domain"
  }

  as = concept.r2-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}

rule "r2-data-catalog" {
  match {
    type = "cloudflare_r2_data_catalog"
  }

  as = concept.r2-data-catalog

  relation "catalogs" {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }
}
