
concept "colab-enterprise-configuration" {
  description = "A runtime template or schedule configuring Colab Enterprise execution."
}


rule "colab-enterprise-runtime-template" {
  match {
    type = "google_colab_runtime_template"
  }

  as = concept.colab-enterprise-configuration
}

rule "colab-enterprise-schedule" {
  match {
    type = "google_colab_schedule"
  }

  as = concept.colab-enterprise-configuration
}
