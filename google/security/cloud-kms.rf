concept "cloud-kms-key-ring" {
  description = "A Cloud KMS key ring organizing keys in one Google Cloud location."
}

concept "cloud-kms-key-version" {
  description = "A cryptographic key version belonging to a Cloud KMS key."
}

rule "cloud-kms-key-ring" {
  match {
    type = "google_kms_key_ring"
  }

  as = concept.cloud-kms-key-ring
}

rule "cloud-kms-key" {
  match {
    type = "google_kms_crypto_key"
  }

  as = concept.encryption-key

  context {
    as  = context.ownership
    to  = concept.cloud-kms-key-ring
    via = source.key_ring
  }
}

rule "cloud-kms-key-version" {
  match {
    type = "google_kms_crypto_key_version"
  }

  as = concept.cloud-kms-key-version

  contribution {
    to  = concept.encryption-key
    via = source.crypto_key
  }
}
