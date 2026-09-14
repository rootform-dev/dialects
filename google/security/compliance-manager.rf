
concept "compliance-manager-configuration" {
  description = "A cloud control or deployment configuring a Compliance Manager framework."
}


rule "compliance-manager-cloud-control" {
  match {
    type = "google_cloud_security_compliance_cloud_control"
  }

  as = concept.compliance-manager-configuration
}

rule "compliance-manager-framework-deployment" {
  match {
    type = "google_cloud_security_compliance_framework_deployment"
  }

  as = concept.compliance-manager-configuration
}
