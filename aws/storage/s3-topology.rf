rule "s3-bucket" {
  match {
    type = "aws_s3_bucket"
  }

  as = rf.concept.object-storage-container
}

rule "s3-bucket-versioning" {
  match {
    type = "aws_s3_bucket_versioning"
  }

  as = concept.storage-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket
  }
}

rule "s3-bucket-server-side-encryption-configuration" {
  match {
    type = "aws_s3_bucket_server_side_encryption_configuration"
  }

  as = concept.storage-configuration

  contribution {
    to  = rf.concept.object-storage-container
    via = source.bucket
  }
}
