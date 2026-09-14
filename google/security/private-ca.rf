concept "private-ca-pool" {
  description = "A Certificate Authority Service pool containing certificate authorities."
}

concept "private-certificate-authority" {
  description = "A managed private certificate authority."
}

rule "private-ca-pool" {
  match {
    type = "google_privateca_ca_pool"
  }

  as = concept.private-ca-pool
}

rule "private-certificate-authority" {
  match {
    type = "google_privateca_certificate_authority"
  }

  as = concept.private-certificate-authority

  context {
    as  = context.ownership
    to  = concept.private-ca-pool
    via = source.pool
  }
}
