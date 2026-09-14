concept "platform-installation" {
  description = "A product activation or installation supporting a Grafana Cloud stack."
}

rule "apps-productactivation-appo11yconfig-v1alpha1" {
  match {
    type = "grafana_apps_productactivation_appo11yconfig_v1alpha1"
  }

  as = concept.platform-installation
}

rule "apps-productactivation-dbo11yconfig-v1alpha1" {
  match {
    type = "grafana_apps_productactivation_dbo11yconfig_v1alpha1"
  }

  as = concept.platform-installation
}

rule "apps-productactivation-k8so11yconfig-v1alpha1" {
  match {
    type = "grafana_apps_productactivation_k8so11yconfig_v1alpha1"
  }

  as = concept.platform-installation
}

rule "apps-secret-keeper-activation-v1beta1" {
  match {
    type = "grafana_apps_secret_keeper_activation_v1beta1"
  }

  as = concept.platform-installation
}

rule "cloud-plugin-installation" {
  match {
    type = "grafana_cloud_plugin_installation"
  }

  as = concept.platform-installation

  contribution {
    to  = concept.observability-tenant
    via = source.stack_slug
  }
}

rule "k6-installation" {
  match {
    type = "grafana_k6_installation"
  }

  as = concept.platform-installation

  contribution {
    to  = concept.observability-tenant
    via = source.stack_id
  }
}

rule "synthetic-monitoring-installation" {
  match {
    type = "grafana_synthetic_monitoring_installation"
  }

  as = concept.platform-installation

  contribution {
    to  = concept.observability-tenant
    via = source.stack_id
  }
}
