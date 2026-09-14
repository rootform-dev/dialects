concept "storage-integration" {
  description = "A Snowflake storage integration delegating access to external cloud object storage."
}

concept "external-volume" {
  description = "A Snowflake external volume containing one or more cloud storage locations."
}

concept "catalog-integration" {
  description = "A Snowflake catalog integration connecting Iceberg metadata to an external catalog."
}

rule "storage-integration" {
  match {
    type = "snowflake_storage_integration"
  }

  as = concept.storage-integration

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[0]
  }

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[1]
  }

}

rule "aws-storage-integration" {
  match {
    type = "snowflake_storage_integration_aws"
  }

  as = concept.storage-integration

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[0]
  }

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[1]
  }

}

rule "azure-storage-integration" {
  match {
    type = "snowflake_storage_integration_azure"
  }

  as = concept.storage-integration

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[0]
  }

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[1]
  }
}

rule "gcs-storage-integration" {
  match {
    type = "snowflake_storage_integration_gcs"
  }

  as = concept.storage-integration

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[0]
  }

  relation "authorizes-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_allowed_locations[1]
  }
}

rule "external-volume" {
  match {
    type = "snowflake_external_volume"
  }

  as = concept.external-volume

  relation "uses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_location[0].storage_base_url
  }

  relation "uses-object-storage" {
    to  = rf.concept.object-storage-container
    via = source.storage_location[1].storage_base_url
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.storage_location[0].encryption_kms_key_id
  }
}

rule "aws-glue-catalog-integration" {
  match {
    type = "snowflake_catalog_integration_aws_glue"
  }

  as = concept.catalog-integration

}

rule "iceberg-rest-catalog-integration" {
  match {
    type = "snowflake_catalog_integration_iceberg_rest"
  }

  as = concept.catalog-integration

}

rule "object-storage-catalog-integration" {
  match {
    type = "snowflake_catalog_integration_object_storage"
  }

  as = concept.catalog-integration
}

rule "open-catalog-integration" {
  match {
    type = "snowflake_catalog_integration_open_catalog"
  }

  as = concept.catalog-integration
}
