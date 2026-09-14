concept "customer-key-management" {
  description = "MongoDB Atlas project-level encryption at rest using customer-managed cloud keys."
}

concept "security-configuration" {
  description = "A security configuration supporting a MongoDB Atlas project."
}

rule "encryption-at-rest" {
  match {
    type = "mongodbatlas_encryption_at_rest"
  }

  as = concept.customer-key-management

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "uses-key" {
    to  = concept.encryption-key
    via = source.aws_kms_config[0].customer_master_key_id
  }

  relation "uses-key" {
    to  = concept.encryption-key
    via = source.azure_key_vault_config[0].key_identifier
  }

  relation "uses-key" {
    to  = concept.encryption-key
    via = source.google_cloud_kms_config[0].key_version_resource_id
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.aws_kms_config[0].role_id
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.azure_key_vault_config[0].role_id
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.google_cloud_kms_config[0].role_id
  }
}

rule "encryption-private-endpoint" {
  match {
    type = "mongodbatlas_encryption_at_rest_private_endpoint"
  }

  as = concept.private-endpoint

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "auditing" {
  match {
    type = "mongodbatlas_auditing"
  }

  as = concept.security-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}
