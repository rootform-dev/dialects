concept "cloud-dns-record-set" {
  description = "A DNS record set managed inside a Cloud DNS managed zone."
}

rule "cloud-dns-managed-zone" {
  match {
    type = "google_dns_managed_zone"
  }

  as = concept.dns-zone
}

rule "cloud-dns-record-set" {
  match {
    type = "google_dns_record_set"
  }

  as = concept.cloud-dns-record-set

  contribution {
    to  = concept.dns-zone
    via = source.managed_zone

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}
