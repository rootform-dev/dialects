

concept "application-configuration" {
  description = "A template, embedding, or deployment configuration supporting Databricks applications."
}



rule "apps-custom-template" {
  match {
    type = "databricks_apps_settings_custom_template"
  }

  as = concept.application-configuration
}

rule "dashboard-embedding-access-policy" {
  match {
    type = "databricks_aibi_dashboard_embedding_access_policy_setting"
  }

  as = concept.application-configuration
}

rule "dashboard-embedding-approved-domains" {
  match {
    type = "databricks_aibi_dashboard_embedding_approved_domains_setting"
  }

  as = concept.application-configuration
}
