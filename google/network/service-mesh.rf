

concept "network-services-route" {
  description = "An HTTP, gRPC, TCP, or TLS route contributing traffic policy."
}



rule "network-services-http-route" {
  match {
    type = "google_network_services_http_route"
  }

  as = concept.network-services-route
}

rule "network-services-grpc-route" {
  match {
    type = "google_network_services_grpc_route"
  }

  as = concept.network-services-route
}

rule "network-services-tcp-route" {
  match {
    type = "google_network_services_tcp_route"
  }

  as = concept.network-services-route
}

rule "network-services-tls-route" {
  match {
    type = "google_network_services_tls_route"
  }

  as = concept.network-services-route
}
