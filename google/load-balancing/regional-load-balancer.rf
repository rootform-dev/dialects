rule "regional-load-balancer" {
  match {
    type  = "google_compute_forwarding_rule"
    where = source.load_balancing_scheme != ""
  }

  as = concept.load-balancer
}
