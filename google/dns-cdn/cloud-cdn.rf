concept "cloud-cdn-service" {
  description = "A Cloud CDN or Media CDN edge delivery service."
}


rule "cloud-cdn-backend-bucket" {
  match {
    type  = "google_compute_backend_bucket"
    where = source.enable_cdn == true
  }

  as = concept.cloud-cdn-service
}

rule "media-cdn-service" {
  match {
    type = "google_network_services_edge_cache_service"
  }

  as = concept.cloud-cdn-service
}
