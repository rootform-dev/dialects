rule "kms-key" {
  match {
    type = "aws_kms_key"
  }

  as = concept.encryption-key
}

rule "kms-alias" {
  match {
    type = "aws_kms_alias"
  }

  as = concept.key-alias

  contribution {
    to  = concept.encryption-key
    via = source.target_key_id
  }
}
